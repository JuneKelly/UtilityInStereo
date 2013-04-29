namespace :phases do
  desc "give order_index values to existing phases" 
  
  task make_order: :environment do
    
    puts ">> Populating order_index fields of Phase table..."

    all_projects = Project.all

    all_projects.each do |project|
      project_phases = project.phases.order("created_at ASC")
      project_phases.each_with_index do |phase, i|
        phase.update_column('order_index', i)
      end
    end
  end
end