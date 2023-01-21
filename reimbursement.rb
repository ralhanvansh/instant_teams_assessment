#Assumptions
  #1. If the project start and end date are the same, it is considered a travel day and counted only once.
  #2. If two projects' end dates and start dates overlap, then that day is considered a full day(of the project which is ending) 
  #   and is only counted once.

require 'date'

def calculate_reimbursement(projects)
  reimbursement_total = 0
  projects.each_with_index do |project, index|
    start_date = Date.parse(project[1])
    end_date = Date.parse(project[2])
    city_type = project[0]
    diff = (end_date - start_date).to_i + 1
    
    lc_fd = 0
    lc_td = 0
    hc_fd = 0
    hc_td = 0
    
    if city_type == "low_cost"
      if diff == 1
        lc_td += 1
      else
        lc_fd += (diff - 2)
        lc_td += 2
      end
    else #city_type == "high_cost"
      if diff == 1
        hc_td += 1
      else
        hc_fd += diff - 2
        hc_td += 2
      end
    end
  
    if index < projects.length-1
      next_start_date = Date.parse(projects[index + 1][1])
      if next_start_date == end_date
        if city_type == "high_cost"
          hc_fd += 1
          hc_td -= 1
        else
          lc_fd += 1
          lc_td -= 1
        end
      end
    end
    
    if index > 0
      previous_end_date = Date.parse(projects[index - 1][2])
      if previous_end_date == start_date
        if city_type == "high_cost"
          hc_td -= 1
        else
          lc_td -= 1
        end
      end
    end
    reimbursement_total += reimbursement(lc_fd, lc_td, hc_fd, hc_td)
  end
  return reimbursement_total
end


def reimbursement(lc_fd, lc_td, hc_fd, hc_td)
    return (lc_fd * 75 + lc_td * 45 + hc_fd * 85 + hc_td * 55)
end

def set(number)  
  case number
  when 1
    return [["low_cost", "9/1/15", "9/3/15"]]
  when 2
    return [["low_cost", "9/1/15", "9/1/15"], ["high_cost", "9/2/15", "9/6/15"], ["low_cost", "9/6/15", "9/8/15"]]
  when 3
    return [["low_cost", "9/1/15", "9/3/15"], ["high_cost", "9/5/15", "9/7/15"], ["high_cost", "9/8/15", "9/8/15"]]
  when 4
    return [["low_cost", "9/1/15", "9/1/15"], ["low_cost", "9/1/15", "9/1/15"], ["high_cost", "9/2/15", "9/2/15"], ["high_cost", "9/2/15", "9/3/15"]]
  end
end

puts "Please enter below the set number e.g 1, 2, 3 or 4"
puts "Enter set no: "
set_no = gets.chomp.to_i
cost = calculate_reimbursement(set(set_no))
puts "Total Reimbursement of set #{set_no}: #{cost}"
