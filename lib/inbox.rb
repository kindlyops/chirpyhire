class Inbox
  def initialize(organization:)
    @organization = organization
  end

  def tasks
    organization.outstanding_activities.order(created_at: :desc).decorate
  end

  def task_groups
    tasks.group_by(&:day).map{ |title, tasks| TaskGroup.new(title, tasks) } || null_task_group
  end

  private

  def null_task_group
    TaskGroup.new("Today #{Time.now.strftime('%B %d')}", [])
  end

  attr_reader :organization

  TaskGroup = Struct.new(:title, :tasks)
end
