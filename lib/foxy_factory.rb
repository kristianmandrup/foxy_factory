module Foxy    
  class Factory
    attr_reader :ns_registry, :base_namespace

    class ConstantNotFoundError < StandardError
    end

    class ConstantIsNotClassError < StandardError
    end   

    class ConstantIsNotModuleError < StandardError
    end

          
    def initialize(*namespaces)
      # raise ArgumentError, "Factory must be initialized with an array of modules to set the base namespace" if namespaces.empty?                                                     
      @ns_registry = namespaces.last.kind_of?(Hash) ? remove_last(namespaces) : {}
      @base_namespace = namespace(namespaces)
    end

    def create(*args, &block)
      if !args.last.kind_of?(Hash) || !args.last[:args] 
        raise ArgumentError, "Last argument before block must be a hash of type :args => [...]" if block
        raise ArgumentError, "Last argument must be a hash of type :args => [...]"
      end
      instance_args = args.delete(args.last)[:args]      
      ns_list, name = parse_args(args)       
      namespaces = get_namespaces(ns_list)      
      obj = find_class(namespaces, name).new *instance_args 
      if block
        block.arity < 1 ? obj.instance_eval(&block) : block.call(obj)
      end
    end        

    def find_class(*args)      
      ns_list, name = parse_args(args)       
      namespaces = get_namespaces(ns_list)
      clazz = find_constant(*args)
      return clazz if clazz.is_a? Class     
      ns = full_ns_name(namespaces, name) 
      raise Factory::ConstantIsNotClassError, "#{ns} is not a class"
    end

    def find_module(*args)                    
      ns_list, name = parse_args(args)      
      namespaces = get_namespaces(ns_list)
      m_dule = find_constant(*args)   
      return m_dule if m_dule.is_a?(Module)
      ns = full_ns_name(namespaces, name) 
      raise Factory::ConstantIsNotModuleError, "#{ns} is not a module"
    end

    def find_module!(*args)                    
      ns_list, name = parse_args(args)      
      namespaces = get_namespaces(ns_list)
      m_dule = find_constant(*args)   
      return m_dule if m_dule.is_a?(Module) && !m_dule.is_a?(Class)     
      ns = full_ns_name(namespaces, name) 
      raise Factory::ConstantIsNotModuleError, "#{ns} is not a module"
    end

    
    def find_constant(*args) 
      ns_list, name = parse_args(args) 
      namespaces = get_namespaces(ns_list)      
      ns = namespace(namespaces)     
      
      # put entry in cache for namespace if not present 
      register_namespace(ns) if !registered?(ns)

      # get namespace entry in cache
      cache = ns_cache(ns)                                                      
      begin    
        if !cache[name]     
          full_name = ns_name(ns, name) 
          cache[name] = constantize(full_name)
        end 
        cache[name]
      rescue
        raise Factory::ConstantNotFoundError, "No constant found for #{camelize(name)} in namespace #{real_ns_name(ns)}"
      end
    end
    
    protected  
      # From ActiveSupport/inflector.rb
      def constantize(camel_cased_word)
        Factory.get_const(camel_cased_word)
      end 

      def self.get_const(camel_cased_word)
        names = camel_cased_word.split('::')
        names.shift if names.empty? || names.first.empty?
        constant = Object
        names.each do |name|
          constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
        end
        constant
      end       

      def real_ns_name(ns)
        return camelize(base_namespace) if ns == 'RootNs'
        ns
      end

      def parse_args(args)
        raise ArgumentError, "Supplied options must not be empty" if !args || args.empty?
        ns_list = [] if args.size == 1
        ns_list = args[0..-2] if args.size > 1
        name = args.last
        [ns_list, name]
      end  
      
      
      def get_namespaces(ns_list)      
        return [:root_ns] if !ns_list || ns_list.empty?
        ns_list      
      end
    
      def remove_last(namespaces)    
        namespaces.delete(namespaces.last)
      end    
    
      def register_namespace(ns)        
        ns_registry[ns] = {}        
      end

      def registered?(ns)       
        ns_cache(ns)
      end

      def ns_cache(ns)
        ns_registry[ns]
      end

      def ns_name(ns, name)   
        return "#{base_namespace}::#{camelize(name)}" if ns == 'RootNs'
        "#{base_namespace}::#{ns}::#{camelize(name)}"
      end

      def full_ns_name(*namespaces, name)
        ns = namespace(namespaces)
        ns_name(ns, name)
      end
      
      def namespace(namespaces)
        raise ArgumentError, "Argument must be an array of namespaces" if !namespaces.kind_of? Array
        namespaces.map{|n| camelize(n.to_s)}.join('::')        
      end 
      
      def camelize(str)
        str.to_s.split(/[^a-z0-9]/i).map{|w| w.capitalize}.join
      end
      
  end  
end
