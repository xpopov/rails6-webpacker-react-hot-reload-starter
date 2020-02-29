class ArrayWithIndifferentKeys
  def self.load(array)
    array.present? ? array.map{ |i| OpenStruct.new(i.symbolize_keys) } : []
  end
  
  def self.dump(array)
    array.present? ? array.map{ |i| Deep.to_h(i) } : []
  end
end