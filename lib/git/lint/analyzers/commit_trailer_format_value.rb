# frozen_string_literal: true

module Git
  module Lint
    module Analyzers
      # Analyzes commit trailer format value.
      class CommitTrailerFormatValue < Abstract
        include Import[pattern: "trailers.format"]

        def valid? = affected_commit_trailers.empty?

        def issue
          return {} if valid?

          {
            hint: "Use format: #{filter_list.to_hint}.",
            lines: affected_commit_trailers
          }
        end

        protected

        def load_filter_list
          Kit::FilterList.new configuration.commits_trailer_format_value_includes
        end

        def invalid_line? trailer
          trailer.key.match?(pattern) && !trailer.value.match?(value_pattern)
        end

        def value_pattern = /\A#{Regexp.union filter_list.to_regexp}\Z/
      end
    end
  end
end
