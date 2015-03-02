require 'spec_helper'

describe ActiveTriples::RepositoryStrategy do
  subject { described_class.new(rdf_source) }
  let(:rdf_source) { ActiveTriples::Resource.new }

  it_behaves_like 'a persistence strategy'

  describe '#persist!' do
    it 'writes to #repository' do
      rdf_source << RDF::Statement.new(RDF::Node.new, RDF::DC.title, 'moomin')
      subject.persist!
      expect(subject.repository.statements)
          .to contain_exactly *rdf_source.statements
    end
  end

  describe '#repository' do
    it 'gives a repository when none is configured' do
      expect(subject.repository).to be_a RDF::Repository
    end

    it 'defaults to an ad-hoc in memory RDF::Repository' do
      expect(subject.repository).to be_ephemeral
    end

    context 'with repository configured' do
      before do
        allow(subject.obj.singleton_class).to receive(:repository)
                                               .and_return(:my_repo)
      end

      let(:repo) { double('repo') }

      it 'when repository is not registered raises an error' do
        expect { subject.repository }
          .to raise_error ActiveTriples::RepositoryNotFoundError
      end

      it 'gets repository' do
        allow(ActiveTriples::Repositories.repositories)
          .to receive(:[]).with(:my_repo).and_return(repo)
        expect(subject.repository).to eq repo
      end
    end
  end
end
