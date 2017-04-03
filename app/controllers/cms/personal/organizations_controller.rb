module Cms
  module Personal
    class OrganizationsController < Cms::BaseController
      before_filter :need_login
      def index
        @organizations = ::Personal::Organization.permitted(current_employee)
      end

      def set_roles
        @organization = ::Personal::Organization.find(params[:id])
        @roles = ::Personal::Role.all
      end

      def commit_roles
        @organization = ::Personal::Organization.find(params[:id])

        if  params[:set_roles].nil?
          role_ids = []
        else
          role_ids = params[:set_roles][:roles_id]
        end

        @organization.role_ids = role_ids
        @organization.save
        redirect_to "/cms/personal/organizations/#{@organization.id}/set_roles"

      end
    end
  end
end