class MigrateRoles < ActiveRecord::Migration[7.0]
  def up
    User.find_each do |user|
      if user.organization_id.present?
        org = Organization.find_by_id(user.organization_id)
        user.add_role(:org_user, org) if org
      end
      if user.partner_id.present?
        partner = Partners::Partner.find_by_id(user.partner_id)
        user.add_role(:partner, partner)
      end
      if user.read_attribute(:super_admin)
        user.add_role(:super_admin)
      elsif user.read_attribute(:organization_admin)
        org = Organization.find_by_id(user.organization_id)
        user.add_role(:org_admin, org) if org
      end
    end

  end

  def down
  end
end
