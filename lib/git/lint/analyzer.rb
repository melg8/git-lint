# frozen_string_literal: true

module Git
  module Lint
    # Runs all analyzers.
    class Analyzer
      include Import[:configuration]

      # rubocop:todo Metrics/CollectionLiteralLength
      ANALYZERS = [
        Analyzers::CommitAuthorCapitalization,
        Analyzers::CommitAuthorEmail,
        Analyzers::CommitAuthorName,
        Analyzers::CommitBodyBullet,
        Analyzers::CommitBodyBulletCapitalization,
        Analyzers::CommitBodyBulletDelimiter,
        Analyzers::CommitBodyLeadingLine,
        Analyzers::CommitBodyLineLength,
        Analyzers::CommitBodyParagraphCapitalization,
        Analyzers::CommitBodyPhrase,
        Analyzers::CommitBodyPresence,
        Analyzers::CommitBodySingleBullet,
        Analyzers::CommitBodyTrackerShorthand,
        Analyzers::CommitSignature,
        Analyzers::CommitSubjectLength,
        Analyzers::CommitSubjectPrefix,
        Analyzers::CommitSubjectSuffix,
        Analyzers::CommitTrailerCollaboratorCapitalization,
        Analyzers::CommitTrailerCollaboratorEmail,
        Analyzers::CommitTrailerCollaboratorKey,
        Analyzers::CommitTrailerCollaboratorName,
        Analyzers::CommitTrailerDuplicate,
        Analyzers::CommitTrailerFormatKey,
        Analyzers::CommitTrailerFormatValue,
        Analyzers::CommitTrailerIssueKey,
        Analyzers::CommitTrailerIssueValue,
        Analyzers::CommitTrailerSignerCapitalization,
        Analyzers::CommitTrailerSignerEmail,
        Analyzers::CommitTrailerSignerKey,
        Analyzers::CommitTrailerSignerName,
        Analyzers::CommitTrailerTrackerKey,
        Analyzers::CommitTrailerTrackerValue
      ].freeze
      # rubocop:enable Metrics/CollectionLiteralLength

      # rubocop:disable Metrics/ParameterLists
      def initialize(
        analyzers: ANALYZERS,
        collector: Collector.new,
        reporter: Reporters::Branch,
        **
      )
        super(**)
        @analyzers = analyzers
        @collector = collector
        @reporter = reporter
      end
      # rubocop:enable Metrics/ParameterLists

      def call commits: Commits::Loader.new.call
        process commits
        a_reporter = reporter.new(collector:)
        block_given? ? yield(collector, a_reporter) : [collector, a_reporter]
      end

      private

      attr_reader :analyzers, :collector, :reporter

      def process commits
        collector.clear
        commits.value_or([]).map { |commit| analyze commit }
      end

      def analyze(commit) = enabled.map { |id| collector.add load_analyzer(commit, id) }

      # :reek:FeatureEnvy
      def enabled
        configuration.to_h
                     .select { |key, value| key.end_with?("enabled") && value == true }
                     .keys
                     .map { |key| key.to_s.sub!("commits_", "commit_").delete_suffix! "_enabled" }
      end

      def load_analyzer commit, id
        analyzers.find { |analyzer| analyzer.id == id }
                 .then { |analyzer| analyzer.new commit }
      end
    end
  end
end
