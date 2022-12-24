# frozen_string_literal: true

module Git
  module Lint
    module Analyzers
      # Analyzes author name for minimum parts of name.
      class CommitAuthorName < Abstract
        include Import[validator: "validators.name"]

        def valid? = validator.new(commit.author_name, minimum:).valid?

        def issue
          return {} if valid?

          {hint: "Author name must consist of #{minimum} parts (minimum)."}
        end

        private

        def minimum = settings.minimum
      end
    end
  end
end
