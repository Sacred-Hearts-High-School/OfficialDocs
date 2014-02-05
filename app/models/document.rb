# encoding: UTF-8

require 'iconv' unless String.method_defined?(:encode)
require 'csv'
require 'roo'

class Document < ActiveRecord::Base

   belongs_to :user

   def self.import(file)

      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)

      (2..spreadsheet.last_row).each do |i|

         # 有收文號才需要匯入，以免匯入空資料
         if spreadsheet.row(i)[1] 
               document = Document.new

               # 第一個欄位原為民國年，修改為西元年之後存入 received_at 欄位
               rd = spreadsheet.row(i)[0].split('.')
               year=rd[0].to_i + 1911
               month=rd[1].to_i
               day=rd[2].to_i
               document.received_at = DateTime.new(year,month,day)
               
               document.received_no = spreadsheet.row(i)[1]
               document.sent_from= spreadsheet.row(i)[2]
               document.doc_type= spreadsheet.row(i)[3]
               document.sent_no= spreadsheet.row(i)[4]
               document.title= spreadsheet.row(i)[5]
               document.office= spreadsheet.row(i)[6]
             #  document.user= spreadsheet.row(i)[7]
             #  document.user_get= spreadsheet.row(i)[8]
             #  document.user_back= spreadsheet.row(i)[9]
               document.save!
         end
      end
   end

   def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "不支援這個檔案格式: #{file.original_filename}"
      end
   end

end
