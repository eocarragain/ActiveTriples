shared_examples 'a persistence strategy' do
  shared_context 'with changes' do
    before do
      subject.obj << RDF::Statement.new(RDF::Node.new, RDF::DC.title, 'moomin')
    end
  end

  describe '#persist!' do
    xit 'evaluates false with no changes' do
      expect(subject.persist!).to be_falsey
    end

    context 'with changes' do
      include_context 'with changes'
      it 'evaluates false with no changes' do
        expect(subject.persist!).to be_truthy
      end
    end
  end

  describe '#persisted?'
end
