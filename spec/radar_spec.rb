require "spec_helper"

describe Radar do
  describe '#check_radar without partial matching' do
    subject { Radar.new(enemy_path, radar_path)  }

    let!(:radar_path){ "spec/resources/radar/radar.txt" }
    let!(:path_error){ "Wrong params, check if the path is correct" }
    let!(:file_error){ "Empty file, check if the files are filled" }
   
    context "when the radar detect an enemy" do
      let!(:enemy_path){ "spec/resources/enemy/enemy1.txt" }
      
      it "successfully" do
        expect(subject.check_radar).to eq(true)
      end
    end

    context "when no enemy was found" do
      let!(:enemy_path){ "spec/resources/enemy/enemy2.txt" }

      it "on the radar" do
        expect(subject.check_radar).to eq(false)
      end
    end

    context "when the enemy path is wrong" do
      let!(:enemy_path){ "spec/enemy2.txt" }

      it "raise an error" do
        expect{subject.check_radar}.to raise_error(path_error)
      end
    end

    context "when the radar path is wrong" do
      let!(:enemy_path){ "spec/radar.txt" }

      it "raise an error" do
        expect{subject.check_radar}.to raise_error(path_error)
      end
    end

    context "when the enemy file is empty" do
      let!(:enemy_path){ "spec/resources/enemy/empty_enemy.txt" }

      it "raise en error" do
        expect{subject.check_radar}.to raise_error(file_error)
      end
    end

    context "when the radar file is empty" do
      let!(:enemy_path){ "spec/resources/radar/empty_radar.txt" }

      it "raise an error" do
        expect{subject.check_radar}.to raise_error(file_error)
      end
    end
  end

  describe '#check_radar with partial matching' do
    subject { Radar.new(enemy_path, radar_path, true)  }

    let!(:radar_path){ "spec/resources/radar/partial_matching_radar.txt" }
    let!(:path_error){ "Wrong params, check if the path is correct" }
    let!(:file_error){ "Empty file, check if the files are filled" }
   
    context "when the radar detect an enemy" do
      let!(:radar_path){ "spec/resources/radar/partial_matching_radar.txt" }
      let!(:enemy_path){ "spec/resources/enemy/partial_matching_enemy.txt" }
      
      it "successfully" do
        expect(subject.check_radar).to eq(true)
      end
    end

    context "when no enemy was found" do
      let!(:radar_path){ "spec/resources/radar/radar2.txt" }
      let!(:enemy_path){ "spec/resources/enemy/enemy2.txt" }

      it "on the radar" do
        expect(subject.check_radar).to eq(false)
      end
    end
  end
end
