# encoding: utf-8
# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Style::EachForSimpleLoop do
  subject(:cop) { described_class.new }

  OFFENSE_MSG = 'Use `Integer#times` for a simple loop ' \
                'which iterates a fixed number of times.'.freeze

  it 'registers offense for exclusive end range' do
    inspect_source(cop, '(0..10).each {}')
    expect(cop.offenses.size).to eq 1
    expect(cop.messages).to eq([OFFENSE_MSG])
    expect(cop.highlights).to eq(['(0..10).each'])
  end

  it 'registers offense for inclusive end range' do
    inspect_source(cop, '(0...10).each {}')
    expect(cop.offenses.size).to eq 1
    expect(cop.messages).to eq([OFFENSE_MSG])
    expect(cop.highlights).to eq(['(0...10).each'])
  end

  it 'registers offense for inclusive end range' do
    inspect_source(cop, ['(0...10).each do',
                         'end'])
    expect(cop.offenses.size).to eq 1
    expect(cop.messages).to eq([OFFENSE_MSG])
    expect(cop.highlights).to eq(['(0...10).each'])
  end

  it 'does not register offense if range startpoint is not constant' do
    inspect_source(cop, '(a..10).each {}')
    expect(cop.offenses).to be_empty
  end

  it 'does not register offense if range startpoint is not constant' do
    inspect_source(cop, '(0..b).each {}')
    expect(cop.offenses).to be_empty
  end

  it 'does not register offense for inline block with parameters' do
    inspect_source(cop, '(0..10).each { |n| puts n }')
    expect(cop.offenses).to be_empty
  end

  it 'does not register offense for multiline block with parameters' do
    inspect_source(cop, ['(0..10).each do |n|',
                         'end'])
    expect(cop.offenses).to be_empty
  end

  it 'does not register offense for character range' do
    inspect_source(cop, "('a'..'b').each {}")
    expect(cop.offenses).to be_empty
  end

  it 'autocorrects the source with inline block' do
    corrected = autocorrect_source(cop, '(0..10).each {}')
    expect(corrected).to eq '10.times {}'
  end

  it 'autocorrects the source with multiline block' do
    corrected = autocorrect_source(cop, ['(0..10).each do',
                                         'end'])
    expect(corrected).to eq "10.times do\nend"
  end
end
