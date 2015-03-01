module ActiveTriples
  ##
  # Persistence strategy for projecting `RDFSource`s onto the graph of an owning
  # parent source. This allows individual resourcesy to be treated as within the
  # scope of another `RDFSource`.
  class ParentStrategy
    # @!attribute [r] obj
    #   the source to persist with this strategy
    # @!attribute [r] parent
    #   the target parent source for persistence
    attr_reader :obj, :parent

    ##
    # @param obj [RDFSource, RDF::Enumerable] the `RDFSource` (or other
    #   `RDF::Enumerable` to persist with the strategy.
    def initialize(obj)
      @obj = obj
    end

    ##
    # @return [#persist!] the last parent in a chain from `parent` (e.g.
    #   the parent's parent's parent). This is the RDF::Mutable that the
    #   object will project itself on when persisting.
    def final_parent
      raise NilParentError if parent.nil?
      @final_parent ||= begin
        current = self.parent
        while current && current.respond_to?(:parent) && current.parent
          break if current.parent == current
          current = current.parent
        end
        current
      end
    end

    ##
    # Sets the target "parent" source for persistence operations.
    #
    # @param parent [RDFSource] source with a persistence strategy,
    #   must be mutable.
    def parent=(parent)
      raise UnmutableParentError unless parent.is_a? RDF::Mutable
      raise UnmutableParentError unless parent.mutable?
      @parent = parent
    end

    ##
    # Persists the object to the final parent.
    def persist!
      final_parent << @obj
    end

    class NilParentError < RuntimeError; end
    class UnmutableParentError < ArgumentError; end
  end
end
