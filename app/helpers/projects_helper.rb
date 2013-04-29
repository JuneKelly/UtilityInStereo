module ProjectsHelper
  def add_phases(project, options)
    if options.include? 'preproduction'
      add_preproduction(project)
    end
    
    if options.include? 'tracking'
      add_tracking(project)
    end

    if options.include? 'editing'
      add_editing(project)
    end

    if options.include? 'mixing'
      add_mixing(project)
    end

    if options.include? 'mastering'
      add_mastering(project)
    end
  end

  private
    def add_preproduction(project)
      phase_details = <<-eos
        Project start and initial tasks
      eos
      new_phase = project.phases.build(title: "Pre-Production",
                                details: phase_details)
      new_phase.save
    end

    def add_tracking(project)
      phase_details = <<-eos
        Performance and Recording
      eos
      new_phase = project.phases.build(title: "Tracking",
                                details: phase_details)
      new_phase.save
    end

    def add_editing(project)
      phase_details = <<-eos
        Chopping, slicing and correcting
      eos
      new_phase = project.phases.build(title: "Editing",
                                details: phase_details)
      new_phase.save
    end

    def add_mixing(project)
      phase_details = <<-eos
        Sound treatment, processing and manipulation
      eos
      new_phase = project.phases.build(title: "Mixing",
                                details: phase_details)
      new_phase.save
    end

    def add_mastering(project)
      phase_details = <<-eos
        Final processing and polishing
      eos
      new_phase = project.phases.build(title: "Mastering",
                                details: phase_details)
      new_phase.save
    end
end
