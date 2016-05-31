class Inbox
  def initialize(organization:)
    @organization = organization
  end

  def tasks
    organization.tasks.outstanding.order(created_at: :desc).decorate
  end

  def task_groups
    tasks.group_by(&:day).map{ |title, tasks| TaskGroup.new(title, tasks) }
  end

  private

  attr_reader :organization

  TaskGroup = Struct.new(:title, :tasks)
end
