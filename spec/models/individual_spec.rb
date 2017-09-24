require 'spec_helper'

describe Individual do
  #let(:individual) { create(:individual) }

  subject { individual }

  it "create an individual" do
    expect{ create(:individual, twitter: "hector") }.to change{ Individual.count }.by(1)
  end

  it "doesn't allow to create two individuals with the same twitter" do
    create(:individual, twitter: "hector")
    expect{ create(:individual, twitter: "hector") }.to raise_error(/Twitter has already been taken/)
    expect(Individual.count).to eq 1
  end

  it "allow to create two individuals with twitter nil" do
    create(:individual, twitter: nil)
    create(:individual, twitter: nil)
    expect(Individual.count).to eq 2
  end

  it "saves blank twitter as nil" do
    individual = create(:individual, twitter: "")
    expect(individual.reload.twitter).to eq nil
  end

  it "destroy" do
    create(:individual).destroy
  end

  context "#karma" do
    it "+1 when you agree on something" do
      individual = create(:individual)
      karma1 = individual.karma
      create(:agreement, individual: individual)
      individual.reload
      expect(individual.karma).to eq karma1 + 1
    end

    it "+2 when you add that someone agrees on something WITHOUT providing an opinion/reason" do
      individual = create(:individual)
      karma1 = individual.karma
      create(:agreement, individual: create(:individual), added_by_id: individual.id, reason: nil)
      individual.reload
      expect(individual.karma).to eq karma1 + 2
    end

    it "+3 when you add that someone agrees on something providing an opinion/reason" do
      individual = create(:individual)
      karma1 = individual.karma
      create(:agreement, individual: create(:individual), added_by_id: individual.id, reason: "bla bla bla")
      individual.reload
      expect(individual.karma).to eq karma1 + 3
    end
  end
end
