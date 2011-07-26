class CityGrid
  class Listing < Abstraction::SuperHash

    class << self
      def first opts = {}
        new({}).update Details.new(opts)
      end

      def all opts = {}
        MultiDetails.new opts
      end
    end

    def method_missing meth, *args, &block
      load unless @loaded
      send(meth, *args, &block) rescue super
    end

    private

    def load hit_api = true
      extend LoadedMethods
      update_details if hit_api
      @loaded = true
      self
    end

    module LoadedMethods
      def listing_id
        self["id"]
      end

      def reset
        @reviews    = nil
        @offers     = nil
        @categories = nil
        @attributes = nil
        self
      end

      def avg_rating
        review_info.overall_review_rating
      end

      # This is a really hacky way to do this - need to fix
      def summary
        (customer_content.customer_message.value rescue nil) ||
        (editorials.first.editorial_review rescue nil)
      end

      def categories
        @categories ||= extract_categories self["categories"]
      end

      def special_features
        categories.select do |k, v|
          k.downcase.include? "special features"
        end.map do |k, v|
          v
        end.flatten.uniq
      end

      def attributes
        @attributes ||= extract_attributes self["attributes"]
      end

      # Details
      # ---------------- #
      def update_details
        update Details.new :listing_id => listing_id
      end

      # Offers
      # -------------- #
      def offers opts = {}
        Offers.new listing_options(opts)
      end

      # Reviews
      # -------------- #
      def reviews opts = {}
        Reviews.new listing_options(opts)
      end

      private

      def listing_options opts
        {:listing_id => listing_id}.merge(opts)
      end

      # Group categories by their group names
      def extract_categories cats
        cats.inject Hash.new do |hash, tag|

          # iterate through groups if the tag belongs to multiple
          tag["groups"].each do |group|
            name = group["name"]
            hash[name] ||= []
            hash[name] << tag["name"]
          end
          hash
        end
      end

      def extract_attributes attrs
        attrs.inject Hash.new do |hash, attrib|
          key       = attrib["name"]
          val       = attrib["value"]
          hash[key] = val
          hash
        end
      end
    end
  end
end