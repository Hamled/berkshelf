module Berkshelf
  class Source
    include Comparable

    # @return [Berkshelf::SourceURI]
    attr_reader :uri

    # @param [String, Berkshelf::SourceURI] uri
    def initialize(uri)
      @uri        = SourceURI.parse(uri)
      @api_client = APIClient.new(uri)
    end

    # @return [Hash]
    def universe
      @universe ||= api_client.universe
    end

    # @param [String] name
    # @param [String] version
    #
    # @return [APIClient::RemoteCookbook]
    def cookbook(name, version)
      universe.find { |cookbook| cookbook.name == name && cookbook.version == version }
    end

    # @param [String] name
    #
    # @return [APIClient::RemoteCookbook]
    def latest(name)
      versions(name).sort.last
    end

    # @param [String] name
    #
    # @return [Array<APIClient::RemoteCookbook>]
    def versions(name)
      universe.select { |cookbook| cookbook.name == name }
    end

    def to_s
      uri.to_s
    end

    def ==(other)
      return false unless other.is_a?(self.class)
      uri == other.uri
    end

    private

      # @return [Berkshelf::APIClient]
      attr_reader :api_client
  end
end
