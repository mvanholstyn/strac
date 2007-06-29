require File.expand_path( File.join( File.dirname( __FILE__ ), 'boot' ) )

class FindersTest < Test::Unit::TestCase
  include ActiveRecord::ConnectionAdapters
  self.fixture_path = File.join( File.dirname( __FILE__ ), 'fixtures/unit/active_record_base_finders' )
  self.fixtures 'developers', 'books'

  def setup
    @connection = ActiveRecord::Base.connection
  end

  def test_find_by_array1
    developers = Developer.find( :all, :conditions=>[ 'ID IN(?)', [1,2] ] )
    assert_equal( 2, developers.size )
  end
  
  def test_find_by_array2
    developers = Developer.find_all_by_id( [ 1, 2 ] )
    assert_equal( 2, developers.size )
  end  
  
  def test_find_by_array3
    developers = Developer.find_all_by_name( [ 'Zach Dennis', 'John Doe', "The Second Topic's of the day" ] )
    assert_equal( 2, developers.size )
  end
    
  def test_find_by_array4
    developers = Developer.find( :all, :conditions=>{ :id=>[1,2] } )
    assert_equal( 2, developers.size )
  end

  def test_find_by_range
    # there is no difference between ( x..z ) and ( x...z )
    developers = Developer.find( :all, :conditions=>{ :id=>(1..2) } )
    assert_equal( 2, developers.size )
    developers = Developer.find( :all, :conditions=>{ :id=>(1...2) } )
    assert_equal( 2, developers.size )
  end

  def test_find_with_like
    developers = Developer.find( :all, :conditions=>{ :name_like=>'ach' } )
    assert_equal( 1, developers.size )

    developers = Developer.find( :all, :conditions=>{ :name_like=>'Zach' } )
    assert_equal( 1, developers.size )
 
    developers = Developer.find( :all, :conditions=>{ :name_like=>['ach', 'oe'] } )
    assert_equal( 2, developers.size )
  end
  
  def test_find_with_contains
    developers = Developer.find( :all, :conditions=>{ :name_contains=>'ach' } )
    assert_equal( 1, developers.size )

    developers = Developer.find( :all, :conditions=>{ :name_contains=>'Zach' } )
    assert_equal( 1, developers.size )

    developers = Developer.find( :all, :conditions=>{ :name_contains=>['ach', 'oe'] } )
    assert_equal( 2, developers.size )
  end

  def test_find_with_starts_with
    developers = Developer.find( :all, :conditions=>{ :name_starts_with=>'Zach' } )
    assert_equal( 1, developers.size )

    # we shouldn't find a record which starts with the last name Dennis
    developers = Developer.find( :all, :conditions=>{ :name_starts_with=>'Dennis' } )
    assert_equal( 0, developers.size )

    developers = Developer.find( :all, :conditions=>{ :name_starts_with=>['Za', 'Jo'] } )
    assert_equal( 2, developers.size )
  end

  def test_find_with_ends_with
    developers = Developer.find( :all, :conditions=>{ :name_ends_with=>'Dennis' } )
    assert_equal( 1, developers.size )

    # we shouldn't find an issue which ends with the first name Zach
    developers = Developer.find( :all, :conditions=>{ :name_ends_with=>'Zach' } )
    assert_equal( 0, developers.size )

    developers = Developer.find( :all, :conditions=>{ :name_ends_with=>['is', 'oe'] } )
    assert_equal( 2, developers.size )
  end

  def test_find_with_regex
    developers = Developer.find( :all, :conditions=>{ :name=>/^Zach/ } )
    assert_equal( 1, developers.size )

    developers = Developer.find( :all, :conditions=>{ :name=>/Dennis$/ } )
    assert_equal( 1, developers.size )
  end

  def test_find_with_less_than
    developers = Developer.find( :all, :conditions=>{ :id_lt=>2 } )
    assert_equal( 1, developers.size )
  end

  def test_find_with_greater_than
    developers = Developer.find( :all, :conditions=>{ :id_gt=>1 } )
    assert_equal( 2, developers.size )
  end

  def test_find_with_less_than_or_equal_to
    developers = Developer.find( :all, :conditions=>{ :id_lte=>2 } )
    assert_equal( 2, developers.size )
  end

  def test_find_with_greater_than_or_equal_to
    developers = Developer.find( :all, :conditions=>{ :id_gte=>1 } )
    assert_equal( 3, developers.size )
  end

  def test_find_not_equal_to
    developers = Developer.find( :all, :conditions=>{ :id_ne=>9999 } )
    assert_equal( Developer.count, developers.size )

    developers = Developer.find( :all, :conditions=>{ :id_not=>9999 } )
    assert_equal( Developer.count, developers.size )
  end

  def test_find_greater_than_time
    books = Book.find( :all, :conditions=>{ :created_at_gt => Time.now } )
    assert_equal 0, books.size
    
    time = Time.local( 2007, 01, 01 )
    books = Book.find( :all, :conditions=>{ :created_at_gt => time } )
    assert books.size == 2
  end
  
  def test_find_less_than_time
    books = Book.find( :all, :conditions=>{ :created_at_lt => Time.now } )
    assert books.size == 9
    
    time = Time.local( 2004, 01, 01 )
    books = Book.find( :all, :conditions=>{ :created_at_lt => time } )
    assert books.size == 3
  end
  
  def test_find_greater_than_or_equal_to_time
    time = Time.local( 2006, 03, 12, 21, 38, 04 )
    books = Book.find( :all, :conditions=>{ :created_at_gte => time } )
    assert books.size == 3
  end
  
  def test_find_less_than_or_equal_to_time
    time = Time.local( 2004, 03, 12, 21, 38, 04 )
    books = Book.find( :all, :conditions=>{ :created_at_lte => time } )
    assert books.size == 5
  end
  
  def test_find_not_equal_to_time
    books = Book.find( :all, :conditions=>{ :created_at_ne => Time.now } )
    assert books.size == 9
  end
  
  def test_find_not_in_array
    developers = Developer.find( :all, :conditions=>{ :id_ne=>[ 9999 ] } )
    assert_equal( Developer.count, developers.size )

    developers = Developer.find( :all, :conditions=>{ :id_not=>[ 9999 ] } )
    assert_equal( Developer.count, developers.size )
    
    developers = Developer.find( :all, :conditions=>{ :id_not_in=>[ 9999 ] } )
    assert_equal( Developer.count, developers.size )
  end

  def test_find_not_in_range
    developers = Developer.find( :all, :conditions=>{ :id_ne=>( 9998..9999 ) } )
    assert_equal( Developer.count, developers.size )

    developers = Developer.find( :all, :conditions=>{ :id_not=>( 9998..9999 ) } )
    assert_equal( Developer.count, developers.size )
    
    developers = Developer.find( :all, :conditions=>{ :id_not_in=>( 9998..9999 ) } )
    assert_equal( Developer.count, developers.size )
    
    developers = Developer.find( :all, :conditions=>{ :id_not_between=>( 9998..9999 ) } )
    assert_equal( Developer.count, developers.size )
  end

  def test_find_not_matching_regex
    developers = Developer.find( :all, :conditions=>{ :id_ne=>/9999/ } )
    assert_equal( Developer.count, developers.size )

    developers = Developer.find( :all, :conditions=>{ :id_not=>/9999/ } )
    assert_equal( Developer.count, developers.size )
    
    developers = Developer.find( :all, :conditions=>{ :id_does_not_match=>/9999/ } )
    assert_equal( Developer.count, developers.size )
  end

  def test_find_with_string_and_hash
    developers = Developer.find( :all, 
      :conditions=>[ "name = 'Zach Dennis'", { :id=>1 } ] )
    assert_equal( 1, developers.size )
  end

  def test_find_with_string_and_hash_where_none_match
    developers = Developer.find( :all, 
      :conditions=>[ "id = 1", { :id=>2 } ] )
    assert_equal( 0, developers.size )
  end

  def test_find_with_string_and_hash_where_string_uses_hash_values
    developers = Developer.find( :all, 
      :conditions=>[ "id = :id", { :id=>1 } ] )
    assert_equal( 1, developers.size )
  end

  def test_find_where_value_is_null
    developers = Developer.find( :all,
                                 :conditions=>{ :name=>nil } )
    assert_equal( 1, developers.size )
  end
  

  def test_find_with_duck_typing_to_sql_for_an_id
    search_object = Object.new
    class << search_object
      def to_sql( caller )
        'id=1'
      end
    end
    
    developers = Developer.find( :all, 
      :conditions=>search_object )
    assert_equal( 1, developers.size )
  end

  def test_find_with_duck_typing_to_sql_for_multiple_conditions
    name = Object.new
    class << name
      def to_sql( caller )
        "name='Zach Dennis'"
      end
    end
    
    salary = Object.new
    class << salary
      def to_sql( caller )
        "salary='1'"
      end
    end
    
    developers = Developer.find( :all, 
                                 :conditions=>{ 
                                   :name=>name,
                                   :salary=>salary }
                                 )
    assert_equal( 1, developers.size )
  end
  
  def test_find_with_duck_typing_to_sql_for_multiple_conditions_find_nothing
    name = Object.new
    class << name
      def to_sql( caller )
        "name='Zach Dennis'"
      end
    end
    
    salary = Object.new
    class << salary
      def to_sql( caller )
        "salary='0'"
      end
    end
    
    developers = Developer.find( :all, 
                                 :conditions=>{ 
                                   :name=>name,
                                   :salary=>salary }
                                 )
    assert_equal( 0, developers.size )
  end
  
  def test_find_should_not_break_proper_string_escapes
    assert Book.find_or_create_by_title_and_publisher_and_author_name( "Book1%20Something", "Publisher%20", "%20Author%20" );
  end
  
end
