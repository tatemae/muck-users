require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::Muck::RolesController do

  it { should require_login(:index, :get) }
  it { should require_login(:show, :get) }
  it { should require_login(:new, :get) }
  it { should require_login(:create, :post) }
  it { should require_login(:update, :post) }

  it { should require_role('admin', :index, :get) }
  
end