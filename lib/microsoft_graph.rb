require "odata"
require "microsoft_graph/base"
require "microsoft_graph/base_entity"
require "microsoft_graph/cached_metadata_directory"
require "microsoft_graph/class_builder"
require "microsoft_graph/collection"
require "microsoft_graph/collection_association"
require "microsoft_graph/errors"
require "microsoft_graph/version"

class MicrosoftGraph
  attr_reader :service
  BASE_URL = "https://graph.microsoft.com/v1.0/"

  def initialize(options = {}, &auth_callback)
    @service = OData::Service.new(
      base_url: BASE_URL,
      metadata_file: options[:cached_metadata_file],
      auth_callback: auth_callback
    )
    @association_collections = {}
    unless MicrosoftGraph::ClassBuilder.loaded?
      MicrosoftGraph::ClassBuilder.load!(service)
    end

  end

  def containing_navigation_property(type_name)
    navigation_properties.values.find do |navigation_property|
      navigation_property.collection? && navigation_property.type.name == "Collection(#{type_name})"
    end
  end

  def path; end
end
