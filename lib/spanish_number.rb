#!/bin/env ruby
# encoding: utf-8
require 'i18n'

UNIDADES = ["", "un", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez", "once", "doce", "trece", "catorce", "quince", "dieciseis", "diecisiete", "dieciocho", "diecinueve", "veinte", "veintiun", "veintidos", "veintitres", "veinticuatro", "veinticinco", "veintiseis", "veintisiete", "veintiocho", "veintinueve"]
DECENAS = ["", "diez", "veinte", "treinta", "cuarenta", "cincuenta", "sesenta", "setenta", "ochenta", "noventa"]
CENTENAS = ["", "ciento", "doscientos", "trescientos", "cuatrocientos", "quinientos", "seiscientos", "setecientos", "ochocientos", "novecientos"]
MILLONES = ["mill", "bill", "trill", "cuatrill"]

class Numeric
	rails_locale =  defined?(Rails)? "#{Rails.root}/config/locales/**/*.yml" : ''
	I18n.load_path = Dir[File.join(File.dirname(__FILE__),'locales/**/*.yml'), rails_locale]

	I18n.locale = :es unless defined?(Rails)

  def to_spanish_text(options = {})
		options = {currency: :default, format: :long}.merge!(options)
    final_text = ""
    sprintf( "%.2f", self ) =~ /([^\.]*)(\..*)?/
    int, dec = $1.reverse, $2 ? $2[1..-1].reverse : ""
    int = int.scan(/.{1,6}/).reverse
    int = int.map{ |million| million.scan(/.{1,3}/).reverse}
    int.each_with_index do |sixdigit, index|
	    i = int.length - index
      final_text += solve_million sixdigit
      if (i-2) >= 0
        final_text += " " + MILLONES[ i-2 ]
        final_text += sixdigit == ["1"] ? "ón" : "ones"
      end
    end
    final_text = " cero" if final_text.empty?
    #final_text += mxn dec if currency == 'mxn'
    #final_text[1..-1]
    dec = dec.eql?("") ? "cero" : cents([dec])
		translate_currency(final_text, dec, options[:currency], options[:format] )
  end

  private

  def solve_million sixdigit
    text = ""
    text += solve_thousand sixdigit.first
    if sixdigit.length > 1
			if sixdigit[0].to_i != 0
        text += " mil"
      end
      text += solve_thousand sixdigit.last
    end
    text
  end

  def solve_thousand threedigit
    text = ""
    return "error" if threedigit.length > 3
    text += " " + CENTENAS[ threedigit[2].to_i ] if threedigit.length > 2 && threedigit[2] != '0'
    if threedigit.length >= 2 && threedigit[1].ord > '2'.ord
      text += " " + DECENAS[ threedigit[1].to_i ] if threedigit[1] != '0'
      unit = threedigit[0].to_i
      text += " y" if unit != 0
      text += " " + UNIDADES[ unit ] if unit != 0
    else
			unit = threedigit[0..1].reverse.to_i
      text += " " + UNIDADES[ unit ] if unit != 0
    end
    text
  end

  def mxn cents
    text = ""
    text += " pesos"
    cents = "00" if cents.nil?
    while cents.length < 2 do
      cents << "0"
    end
    text += " " + cents[0..1].to_s + "/100"
    text += " M.N."
  end

	def cents(cnt)
		solve_million(cnt)
	end


  def translate_currency(integer, decimal, currency, format)
		  integer_label =  I18n.t(:integer_label, :scope => "currencies.#{currency}", :default => "")
		  decimal_label =  I18n.t(:decimal_label, :scope => "currencies.#{currency}", :default => "")
		  I18n.t(format, :scope => "currencies.#{currency}.format", :decimal => decimal,
		         :decimal_label => decimal_label, :integer => integer, :integer_label => integer_label)
	  #end
  end
end
