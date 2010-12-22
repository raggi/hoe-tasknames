module Hoe::Tasknames
  VERSION = '1.0.0'

  MAP = {
    'generate_key'     => 'hoe:generate_key',
    'check_manifest'   => 'hoe:check_manifest',
    'check_extra_deps' => 'hoe:check_extra_deps',
    'config_hoe'       => 'hoe:config',
    'debug_gem'        => 'hoe:debug:gem',
    'debug_email'      => 'hoe:debug:email',
    'clobber_docs'     => 'clobber:docs',
    'clobber_package'  => 'clobber:package',
    'clobber_rcov'     => 'clobber:rcov',
    'test_deps'        => 'test:deps'
  }

  REMOVE = %w[audit]

  ALIAS = {
    'newb' => 'boostrap'
  }

  HIDE = %w[
    release_sanity release_to_gemcutter ridocs post_blog post_news
    clobber:docs clobber:package clobber:rcov
  ]

  def initialize_tasknames
    extra_dev_deps << ['hoe-tasknames', ">= #{VERSION}"]
  end

  def define_tasknames_tasks
    altered, adds = {}, {}
    tasknames_filter_tasks(altered, adds)
    tasknames_correct_prerequisites(altered)
    tasknames_tasks.merge!(adds)
    tasknames_aliases
    tasknames_hides
  end

  def tasknames_filter_tasks(altered, adds)
    tasknames_tasks.delete(*REMOVE)
    tasknames_tasks.each do |name, task|
      from = task.name
      if to = MAP[from]
        altered[from] = to
        task.instance_variable_set(:@name, to)
        adds[to] = tasknames_tasks.delete(from)
      end
      task
    end
  end

  def tasknames_correct_prerequisites(altered)
    altered.each do |from, to|
      Rake::Task.tasks.each do |task|
        if idx = task.prerequisites.find_index(from)
          task.prerequisites[idx] = to
        end
      end
      # descriptionless task to ensure that if someone uses
      # Rake::Task[name].invoke it still runs the required task.
      task from => to
    end
  end

  def tasknames_aliases
    ALIAS.each do |from, to|
      d = Rake::Task[from].full_comment
      desc d unless d.nil? || d.empty? # one or t'other
      task from => to
    end
  end

  def tasknames_hides
    HIDE.each do |name|
      t = Rake::Task[name]
      t.instance_variable_set(:@full_comment, nil)
      t.instance_variable_set(:@comment, nil)
    end
  end

  def tasknames_tasks
    Rake.application.instance_variable_get(:@tasks)
  end
end
