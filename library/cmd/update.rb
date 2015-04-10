require_relative '../exceptions.rb'
require_relative '../global.rb'

module Crew

  def self.update(args)
    if args.length > 0
      raise CommandRequresNoArguments
    end

    # ensure GIT_CONFIG is unset as we need to operate on .git/config
    ENV.delete('GIT_CONFIG')

    report = Report.new
    updater = Updater.new
    updater.pull!
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
    attr_reader :initial_revision, :current_revision, :repository

    def initialize
      @repository = Global::REPOSITORY_DIR
    end

    def pull!
      Utils.git "checkout", "-q", "master"

      @initial_revision = read_current_revision

      begin
        # ensure we don't munge line endings on checkout
        Utils.git "config", "core.autocrlf", "false"

        args = ["pull"]
        args << "-q" unless Global::DEBUG.include?(:git)
        args << "origin"
        # the refspec ensures that 'origin/master' gets updated
        args << "refs/heads/master:refs/remotes/origin/master"
        Utils.git *args
      rescue
        Utils.git "reset", "--hard", @initial_revision
        raise
      end

      @current_revision = read_current_revision
    end

    def report
      map = Hash.new { |h,k| h[k] = [] }
      formuladir = Global::FORMULA_DIR.basename.to_s

      if initial_revision and initial_revision != current_revision
        diff.each_line do |line|
          status, *paths = line.split
          src, dst = paths.first, paths.last

          next unless File.extname(dst) == ".rb"
          next unless paths.any? { |p| File.dirname(p) == formuladir }

          case status
          when "A", "M", "D"
            map[status.to_sym] << repository.join(src)
          when /^R\d{0,3}/
            map[:D] << repository.join(src) if File.dirname(src) == formuladir
            map[:A] << repository.join(dst) if File.dirname(dst) == formuladir
          end
        end
      end

      map
    end

    private

    def read_current_revision
      Utils.git("rev-parse", "-q", "--verify", "HEAD").chomp
    end

    def diff
      Utils.git "diff-tree", "-r", "--name-status", "--diff-filter=AMDR", "-M85%", initial_revision, current_revision
    end
  end


  class Report
    def initialize
      @hash = {}
    end

    def fetch(*args, &block)
      @hash.fetch(*args, &block)
    end

    def update(*args, &block)
      @hash.update(*args, &block)
    end

    def empty?
      @hash.empty?
    end

    def dump
      # Key Legend: Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R)
      dump_formula_report(:A, "New Formulae")
      dump_formula_report(:M, "Updated Formulae")
      dump_formula_report(:D, "Deleted Formulae")
    end

    def select_formula(key)
      fetch(key, []).map do |path|
          path.basename(".rb").to_s
      end.sort
    end

    def dump_formula_report(key, title)
      formula = select_formula(key)
      unless formula.empty?
        puts "==> #{title}"
        puts formula
      end
    end
  end
end
