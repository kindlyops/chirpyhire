class PersonPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
        .joins('LEFT JOIN contacts ON contacts.person_id = people.id')
        .joins(broker_contacts_join_clause)
        .where(where_clause, organization.id)
    end

    private

    def broker_contacts_join_clause
      'LEFT JOIN broker_contacts ON broker_contacts.person_id = people.id'
    end

    def where_clause
      'contacts.organization_id = ? OR broker_contacts.id IS NOT NULL'
    end
  end
end
