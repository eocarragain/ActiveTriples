require 'spec_helper'

describe ActiveTriples::RepositoryStrategy do
  subject { described_class.new(rdf_source) }
  let(:rdf_source) { ActiveTriples::Resource.new }

  let(:statement) { RDF::Statement.new(RDF::Node.new, RDF::DC.title, 'moomin') }

  it_behaves_like 'a persistence strategy'

  shared_context 'with repository' do
    before do
      allow(subject.obj.singleton_class).to receive(:repository)
                                             .and_return(:my_repo)
    end
  end

  describe '#persist!' do
    it 'writes to #repository' do
      rdf_source << statement
      subject.persist!
      expect(subject.repository.statements)
          .to contain_exactly *rdf_source.statements
    end
  end

  describe '#reload' do
    it 'when both repository and object are empty returns true' do
      expect(subject.reload).to be true
    end

    context 'with unknown content in repo' do
      include_context 'with repository' do
        before do
          allow(ActiveTriples::Repositories.repositories)
            .to receive(:[]).with(:my_repo).and_return(repo)
          repo << statement
        end

        let(:repo) { RDF::Repository.new }
      end

      # it 'overrides ' do
      #   expect(subject.reload).to be true
      # end
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
      include_context 'with repository'

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