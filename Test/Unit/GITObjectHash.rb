describe "GITObjectHash" do
  before do
    @sha1_str = "bed4001738fa8dad666d669867afaf9f2c2b8c6a"
    @pack_data = [@sha1_str].pack("H*").data
    @hash = GITObjectHash.alloc.initWithString(@sha1_str)
  end

  describe "+packedDataFromString:" do
    before do
      @subj = GITObjectHash.packedDataFromString(@sha1_str)
    end

    should "return NSData" do
      @subj.should.be.kind_of NSData
    end

    should "return data 20 bytes long" do
      @subj.length.should == GITObjectHashPackedLength
    end

    should "return data matching sha1_data" do
      @subj.should === @pack_data
    end
  end

  describe "+unpackedStringFromData:" do
    before do
      @subj = GITObjectHash.unpackedStringFromData(@pack_data)
    end

    should "return NSString" do
      @subj.should.be.kind_of NSString
    end

    should "return a string 40 characters long" do
      @subj.length.should == GITObjectHashLength
    end

    should "return data matching pack_data" do
      @subj.should === @sha1_str
    end
  end

  describe "-unpackedString" do
    should "return NSString" do
      @hash.unpackedString.should.be.kind_of NSString
    end

    should "return a 40 character long string" do
      @hash.unpackedString.length.should == GITObjectHashLength
    end

    should "return the correct string" do
      @hash.unpackedString.should == @sha1_str
    end
  end

  describe "-packedData" do
    should "return NSData" do
      @hash.packedData.should.be.kind_of NSData
    end

    should "return 20 bytes of data" do
      @hash.packedData.length.should == GITObjectHashPackedLength
    end

    should "return the correct data" do
      @hash.packedData.should === @pack_data
    end
  end

  describe "-isEqual:" do
    before do
      @other = GITObjectHash.objectHashWithData(@pack_data)
    end

    should "be true with @hash" do
      @other.isEqual(@hash).should.be.true
    end

    should "be true with @sha1_str" do
      @hash.isEqual(@sha1_str).should.be.true
    end

    should "be true with @pack_data" do
      @hash.isEqual(@pack_data).should.be.true
    end

   should "be false with 1" do
     @hash.isEqual(1).should.be.false
   end

   should "be false with 'hello'" do
     @hash.isEqual("hello").should.be.false
   end
  end

  describe "-isEqualToObjectHash:" do
    should "be true with @hash" do
      GITObjectHash.objectHashWithData(@pack_data).isEqualToObjectHash(@hash).should.be.true
    end
  end

  describe "-isEqualToData:" do
    should "be true with @pack_data" do
      @hash.isEqualToData(@pack_data).should.be.true
    end
  end

  describe "-isEqualToString:" do
    should "be true with @sha1_str" do
      @hash.isEqualToString(@sha1_str).should.be.true
    end
  end
end
