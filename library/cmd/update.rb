require 'rugged'
require_relative '../exceptions.rb'
require_relative '../global.rb'

module Crew

  def self.update(args)
    if args.length > 0
      raise CommandRequresNoArguments
    end

    updater = Updater.new
    updater.pull!

    report = Report.new
    report.update(updater.report)

    if report.empty?
      puts "Already up-to-date."
    else
      puts "Updated Crew from #{updater.initial_revision[0,8]} to #{updater.current_revision[0,8]}."
      report.dump
    end
  end

  private

  class Updater
    attr_reader :initial_revision, :current_revision, :repository, :repository_path

    def initialize
      @repository = Rugged::Repository.new('.')
      @repository_path = Global::REPOSITORY_DIR
    end

    def pull!
      repository.checkout 'master'
      @initial_revision = read_current_revision

      begin
        repository.fetch 'origin', credentials: make_creds
        repository.checkout 'refs/remotes/origin/master'
      rescue
        repository.reset initial_revision, :hard
        raise
      end

      @current_revision = read_current_revision
    end

    def report
      map = { utils: Hash.new { |h,k| h[k] = [] }, libs: Hash.new { |h,k| h[k] = [] } }
      formula_dir = Global::FORMULA_DIR.basename.to_s
      utility_dir = File.join(formula_dir, Global::UTULITY_DIR.basename.to_s)

      if initial_revision and initial_revision != current_revision
        diff.each_delta do |delta|
          src = delta.old_file[:path]
          dst = delta.new_file[:path]

          next unless File.extname(dst) == ".rb"
          next unless [src, dst].any? { |p| File.dirname(p).start_with?(formula_dir) }

          status = delta.status_char.to_s
          type = (src == utility_dir) ? :utils : :libs
          case status
          when "A", "M", "D"
            map[type][status.to_sym] << repository_path.join(src)
          when "R"
            map[type][:D] << repository_path.join(src) if File.dirname(src) == formula_dir
            map[type][:A] << repository_path.join(dst) if File.dirname(dst) == formula_dir
          end
        end
      end

      map
    end

    private

    def read_current_revision
      # git rev-parse -q --verify HEAD"
      repository.rev_parse_oid('HEAD')
    end

    def diff
      # git diff-tree -r --name-status --diff-filter=AMDR -M85% initial_revision current_revision
      init = repository.lookup(initial_revision)
      curr = repository.lookup(current_revision)
      init.diff(curr).find_similar!({ :rename_threshold => 85, :renames => true })
    end

    def make_creds
      if repository.remotes['origin'].url =~ /^git@/
        Rugged::Credentials::SshKey.new(username: 'git',
                                        publickey: File.expand_path("~/.ssh/id_rsa.pub"),
                                        privatekey: File.expand_path("~/.ssh/id_rsa"))
      else
        nil
      end
    end
  end


  class Report
    def initialize
      @hash = { utils: {}, libs: {} }
    end

    def update(h)
      @hash[:utils].update(h[:utils])
      @hash[:libs].update(h[:libs])
    end

    def empty?
      @hash[:utils].empty? and @hash[:libs].empty?
    end

    def dump
      # Key Legend: Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R)
      dump_formula_report(:utils, :M, "Updated Utilities")
      dump_formula_report(:utils, :A, "New Utilities")
      dump_formula_report(:utils, :D, "Deleted Utilities")
      dump_formula_report(:libs, :A, "New Formulae")
      dump_formula_report(:libs, :M, "Updated Formulae")
      dump_formula_report(:libs, :D, "Deleted Formulae")
    end

    private

    def dump_formula_report(type, key, title)
      formula = select_formula(type, key)
      unless formula.empty?
        puts "==> #{title}"
        puts formula
      end
    end

    def select_formula(type, key)
      fetch(type, key, []).map do |path|
          path.basename(".rb").to_s
      end.sort
    end

    def fetch(type, *args)
      @hash[type].fetch(*args)
    end
  end
end
