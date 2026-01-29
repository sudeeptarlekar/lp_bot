# frozen_string_literal: true

describe Bot::TheTrainLine::Result do
  describe '#success?' do
    it 'returns true when initialized with success: true' do
      result = described_class.new(success: true)

      expect(result.success?).to be(true)
    end

    it 'returns false when initialized with success: false' do
      result = described_class.new(success: false)

      expect(result.success?).to be(false)
    end
  end

  describe '#failure?' do
    it 'returns false when initialized with success: true' do
      result = described_class.new(success: true)

      expect(result.failure?).to be(false)
    end

    it 'returns true when initialized with success: false' do
      result = described_class.new(success: false)

      expect(result.failure?).to be(true)
    end
  end

  describe '.success' do
    it 'builds a successful result with data and no error or code' do
      data = { foo: 'bar' }
      result = described_class.success(data: data)

      expect(result).to be_a(described_class)
      expect(result.success?).to be(true)
      expect(result.failure?).to be(false)
      expect(result.data).to eq(data)
      expect(result.error).to be_nil
      expect(result.code).to be_nil
    end
  end

  describe '.failure' do
    it 'builds a failed result with error and code and no data' do
      error = 'Not found'
      code  = :not_found
      result = described_class.failure(error: error, code: code)

      expect(result).to be_a(described_class)
      expect(result.success?).to be(false)
      expect(result.failure?).to be(true)
      expect(result.data).to be_nil
      expect(result.error).to eq(error)
      expect(result.code).to eq(code)
    end
  end

  describe 'attribute readers' do
    it 'exposes data, error and code passed to initializer' do
      data  = { journeys: [] }
      error = 'Something went wrong'
      code  = :internal_error

      result = described_class.new(
        success: false,
        data: data,
        error: error,
        code: code
      )

      expect(result.data).to eq(data)
      expect(result.error).to eq(error)
      expect(result.code).to eq(code)
    end
  end
end
