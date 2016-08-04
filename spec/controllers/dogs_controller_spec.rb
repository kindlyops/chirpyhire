require 'rails_helper'

RSpec.describe DogsController, type: :controller do
  describe "#update" do
    # let!(:dog) { Dog.create name: "Fido" }

    context "with toys" do
      # let!(:old_toy) { Toy.create name: "Bone", dog: dog }
      # let!(:old_toys) do
      #   [
      #    old_toy
      #   ]
      # end

      context "and changing toys" do
        # let(:params) do
        #   {
        #     id: dog.id,
        #     dog: {
        #       toys_attributes: [
        #         id: old_toy.id,
        #         name: "Ball"
        #       ]
        #     }
        #   }
        # end

        with_versioning do
          ActiveRecord::Base.logger = Logger.new(STDOUT)
          it "tracks the prior association" do
            dog = Dog.create name: "Fido"
            toy = Toy.create name: "Bone", dog: dog
            old_toys = [toy]

            # put :update, params: params
            dog.update(name: "Dido", toys_attributes: [{id: toy.id, name: "Ball"}])
            dog_0 = dog.versions.last.reify(has_many: true)
            # binding.pry
            expect(dog_0.toys.map(&:name)).to match_array(old_toys.map(&:name))
          end
        end
      end
    end
  end
end
