module Bim
  class BcfIssue < ActiveRecord::Base

    belongs_to :work_package
    belongs_to :project

    class << self
      def in_project(project)
        where(project_id: project.try(:id) || project)
      end

      def with_markup
        select '*',
               extract_xml('/Markup/Topic/Title/text()', 'title'),
               extract_xml('/Markup/Topic/Description/text()', 'description')
      end

      private

      def extract_xml(path, as)
        "(xpath('#{path}', markup))[1] AS #{as}"
      end
    end

    has_many :viewpoints, foreign_key: :issue_id, class_name: "Bim::BcfViewpoint"
    has_many :comments, foreign_key: :issue_id, class_name: "Bim::BcfComment"
  end
end
