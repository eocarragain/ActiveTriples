require 'spec_helper'

describe ActiveTriples::RepositoryStrategy do
  subject { described_class.new(rdf_source) }
  let(:rdf_source) { ActiveTriples::Resource.new }

  it_behaves_like 'a persistence strategy'

end
