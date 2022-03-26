# frozen_string_literal: true

RSpec.shared_context "with commits container" do
  using AutoInjector::Stub

  include_context "with application container"

  let(:repository) { instance_spy GitPlus::Repository, branch_default: "main", branch_name: "test" }
  let(:executor) { class_spy Open3 }

  before { Git::Lint::Import.stub repository:, executor: }

  after { Git::Lint::Import.unstub repository:, executor: }
end
