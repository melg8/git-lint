# frozen_string_literal: true

module Git
  module Lint
    module Analyzers
      class CommitBodyLeadingLine < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error
          }
        end

        def valid?
          message = commit.message
          subject, body = message.split "\n", 2

          return true if !String(subject).empty? && String(body).strip.empty?

          message.match?(/\A.+(\n\n|\#).+/m)
        end

        def issue
          return {} if valid?

          {hint: "Use blank line between subject and body."}
        end
      end
    end
  end
end
