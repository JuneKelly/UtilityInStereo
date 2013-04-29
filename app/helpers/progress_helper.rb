module ProgressHelper

def project_percent_complete(project)
  tasks = project.tasks

  done_tasks = tasks.map do |task|
    tasks if task.is_done? == true
  end

  not_done_tasks = tasks.map do |task|
    task if task.is_done? == false
  end
  

  done_tasks.reject! { |t| t == nil }
  not_done_tasks.reject { |t| t == nil }


  base_ratio = done_tasks.count.to_f / not_done_tasks.count.to_f
  base_percent = base_ratio * 100
  if base_percent.nan?
    return 0.0
  else
    return base_percent
  end
end


private

  def phase_percent_complete(phase)
    
  end

end