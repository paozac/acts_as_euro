module ActsAsEuro
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def acts_as_euro(*attrs)
      attrs.each do |a|
        create_methods_for(a)
      end
    end
    
    private
    
    def create_methods_for(a)
      field_reader = a.to_sym
      field_writer = "#{a}=".to_sym
      whole_reader = "#{a}_whole".to_sym
      whole_writer = "#{a}_whole=".to_sym
      cents_reader = "#{a}_cents".to_sym
      cents_writer = "#{a}_cents=".to_sym
      
      define_method whole_reader do
        send(field_reader).divmod(100)[0] rescue 0
      end
      
      define_method whole_writer do |v|
        n = send(cents_reader).to_i + (v.to_i * 100) rescue nil
        send(field_writer, n) if n
      end
      
      define_method cents_reader do
        "%02d" % (send(field_reader) % 100 ) rescue 0
      end
      
      define_method cents_writer do |v|
        n = send(whole_reader) * 100 + v.to_i rescue nil
        send(field_writer, n) if n
      end
      
      attr_accessible field_reader, whole_reader, cents_reader
    end
  end
end