require 'csv'

class CapTable
	module RowType
		VEST = "VEST"
		CANCEL = "CANCEL"
	end

	def initialize(file_name, target_date, precision)
		raise "Invalid precision value '#{precision}'" unless (0..6).include?(precision)

		@file_name = file_name
		@target_date = Date.parse(target_date)
		@precision = precision
	end

	def call
		cap_table = load_csv
		sorted_cap_table = sort_cap_table(cap_table)
		format_cap_table(sorted_cap_table)
	end

	def load_csv
		cap_table_hash = {}
		CSV.foreach(file_name).with_index do |row, row_number|
			type, employee_id, employee_name, award_id, vest_date, raw_quantity = row

			raise "Award ID not found for row '#{row_number}'" if award_id.empty?

			unless cap_table_hash[award_id]
				cap_table_hash[award_id] = {
					employee_id: employee_id,
					employee_name: employee_name,
					quantity: 0
				}
			end

			raise "Employee ID not found for row '#{row_number}'" if employee_id.empty?
			raise "Employee name not found for row '#{row_number}'" if employee_name.empty?

			next if Date.parse(vest_date) > target_date

			quantity = raw_quantity.to_f.truncate(precision)

			case type
			when RowType::VEST
				cap_table_hash[award_id][:quantity] += quantity
			when RowType::CANCEL
				cap_table_hash[award_id][:quantity] -= quantity
				raise "Cancellation exceeding the number of shares" if cap_table_hash[award_id][:quantity] < 0
			else
				raise "Unknown row type '#{type}'"
			end
		end
		cap_table_hash
	end

	def sort_cap_table(cap_table_hash)
		cap_table_hash.sort_by do |award_id, employee|
			[employee[:employee_id], award_id]
		end
	end

	def format_cap_table(cap_table)
		cap_table.map do |award_id, employee|
			employee_id, employee_name, quantity = employee.values_at(:employee_id, :employee_name, :quantity)
			[employee_id, employee_name, award_id, "%.#{precision}f" % quantity].join(",")
		end.join("\n")
	end

	private

	attr_reader :file_name, :target_date, :precision
end
