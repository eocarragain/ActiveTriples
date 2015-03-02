module ActiveTriples
  ##
  # Persistence strategy for projecting `RDFSource` to `RDF::Repositories`.
  class RepositoryStrategy
    # @!attribute [r] obj
    #   the source to persist with this strategy
    attr_reader :obj

    ##
    # @param obj [RDFSource, RDF::Enumerable] the `RDFSource` (or other
    #   `RDF::Enumerable` to persist with the strategy.
    def initialize(obj)
      @obj = obj
    end

    def persist!
      require 'pry'
      binding.pry
    end

    def persisted?
    end

    def repository
      @repository ||= begin
        repo_sym = obj.singleton_class.repository
        if repo_sym.nil?
          RDF::Repository.new
        else
          repo = Repositories.repositories[repo_sym]
          repo || raise(RepositoryNotFoundError, "The class #{obj.class} expects a repository called #{repo_sym}, but none was declared")
        end
      end
    end
  end
end
