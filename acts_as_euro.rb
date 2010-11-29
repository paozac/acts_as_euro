module ActsAsEuro
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def acts_as_euro(*attrs)
      attrs.each do |a|
        create_methods_for(a)
      end
    end
    
    private
    
    def create_methods_for(a)
      whole_method_reader = "#{a}_whole".to_sym
      whole_method_writer = "#{a}_whole=".to_sym
      cents_method_reader = "#{a}_cents".to_sym
      cents_method_writer = "#{a}_cents=".to_sym
      
      define_method whole_method_reader do
        price.divmod(100)[0] rescue 0
      end
      
      define_method whole_method_writer do |v|
        self.price = price_cents.to_i + (v.to_i * 100) rescue nil
      end
      
      define_method cents_method_reader do
        "%02d" % (price % 100 ) rescue 0
      end
      
      define_method cents_method_writer do |v|
        self.price = price_whole * 100 + v.to_i rescue nil
      end
      
      attr_accessible a.to_sym, whole_method_reader.to_sym, cents_method_reader.to_sym
    end
  end
end