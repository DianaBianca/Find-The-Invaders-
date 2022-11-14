class Radar
  def initialize(enemy_path, radar_path, partial_matching = false) 
    open_files(enemy_path, radar_path)
    setup(partial_matching)
    close_files
  rescue Errno::ENOENT => e
    raise "Wrong params, check if the path is correct"
  end

  def check_radar
    radar.each_with_index do |line, index|
      next if first_character(line).nil?

      return false if last_radar_position(index)

      return true if check_compatibility(first_character(line), last_character(line), index)
    end
  end

  private
  
  attr_reader :radar, :radar_file, :enemy, :enemy_file, :partial_matching, :half_of_the_enemy

  def first_character(line)
    line.index(enemy.first, 0)
  end

  def last_radar_position(index)
    radar.length == index + 1
  end

  def last_character(line)
    enemy_length + first_character(line)
  end
  
  def enemy_length
    enemy.first.length - 1 
  end

  def check_compatibility(first_character, last_character, index)

    next_radar_line = radar[index + 1].slice(first_character..last_character)

    return false unless can_be_enemy?(next_radar_line)

    last_pos = enemy.length + index - 1
    radar_image = radar[index..last_pos].map{|radar_line| radar_line.slice(first_character..last_character)}
 
    return check_partial_matching(radar_image) if partial_matching

    radar_image == enemy
  end

  def check_partial_matching(radar_image)
    partial_image = radar_image[0..half_of_the_enemy]
 
    partial_image == partial_enemy_array
  end

  def partial_enemy_array
    enemy[0..half_of_the_enemy]
  end

  def can_be_enemy?(next_radar_line) 
    next_radar_line == enemy.at(1)
  end

  def open_files(enemy_path, radar_path)  
    @enemy_file = File.open(enemy_path)
    @radar_file = File.open(radar_path)
  end

  def setup(partial_matching)
    @enemy = enemy_file.readlines.map(&:chomp)
    @radar = radar_file.readlines.map(&:chomp)
    @partial_matching = partial_matching
    @half_of_the_enemy = (enemy.length.to_f / 2).ceil
    check_data!
  end

  def check_data!
    error = "Empty file, check if the files are filled"
    raise error if enemy.empty? || radar.empty? 
  end

  def close_files
    radar_file.close
    enemy_file.close
  end
end
