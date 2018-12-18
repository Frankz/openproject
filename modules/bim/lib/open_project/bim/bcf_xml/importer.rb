require 'activerecord-import'

module OpenProject::Bim::BcfXml
  class Importer

    attr_reader :project, :zip, :current_user

    def initialize(project, current_user:)
      @project = project
      @current_user = current_user
    end

    def import!(file)
      Zip::File.open(file) do |zip|
        # Extract all topics of the zip and save them
        synchronize_topics(zip)

        # TODO: Extract documents

        # TODO: Extract BIM snippets
      end
    end

    private

    def synchronize_topics(zip)
      yield_topic_entries(zip)
        .map do |entry|
          issue = Issue.new(project, zip, entry, current_user: current_user).extract!
          issue.save
        end
        .count
    end

    ##
    # Yields topic entries and their uuid from the ZIP files
    # while skipping all other entries
    def yield_topic_entries(zip)
      zip.select { |entry| entry.name.end_with?('markup.bcf') }
    end
  end
end
