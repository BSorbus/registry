class CreateRoleService

  #works
  def work_observer(creator_id=nil)
    role = Role.find_or_create_by!(name: "Obserwator Działań") do |role|
      role.activities += %w(all:work role:work user:work organization:work proposal:work register:work)
      role.note = "<div>Rola służy do obserwowania historii wpisów, działań.<br>(Przypisz tylko Administratorom systemu)</div>"
      role.author_id = creator_id
      role.save!
    end
  end

  # roles
  def role_admin(creator_id=nil)
    role = Role.find_or_create_by!(name: "Administrator Ról Systemowych") do |role|
      role.activities += %w(role:index role:show role:create role:update role:delete role:work)
      role.note = "<div>Rola służy do tworzenia, modyfikowania Ról.<br>(Przypisz tylko zaawansowanym Administratorom systemu)</div>"
      role.author_id = creator_id
      role.save!
    end
  end 

  # users
  def user_admin(creator_id=nil)
    role = Role.find_or_create_by!(name: "Administrator Użytkowników") do |role|
      role.activities += %w(user:index user:show user:create user:update user:delete role:add_remove_role_user user:work)
      role.note = "<div>Rola służy do zarządzania Użytkownikami i przypisywania im Ról Systemowych.<br>(Przypisz tylko zaawansowanym Administratorom systemu)</div>"
      role.author_id = creator_id
      role.save!
    end
  end
  def user_observer(creator_id=nil)
    role = Role.find_or_create_by!(name: "Obserwator Użytkowników") do |role|
      role.activities += %w(user:index user:show)
      role.note = "<div>Rola pozwala przeglądać dane kont Użytkowników.<br>(Przypisz użytkownikom systemu, którzy mają prawo do przeglądania takich danych)</div>"
      role.author_id = creator_id
      role.save!
    end
  end

  # organizations
  def organization_admin(creator_id=nil)
    role = Role.find_or_create_by!(name: "Administrator Organizacji") do |role|
      role.activities += %w(organization:index organization:show organization:create organization:update organization:delete organization:work)
      role.note = "<div>Rola służy do zarządzania wszystkimi Organizacjami.<br>(Przypisz tylko zaawansowanym Administratorom systemu)</div>"
      role.author_id = creator_id
      role.save!
    end
  end 
  def organization_observer(creator_id=nil)
    role = Role.find_or_create_by!(name: "Obserwator Organizacji") do |role|
      role.activities += %w(organization:index organization:show)
      role.note = "<div>Rola służy do wyświetlania informacji o Organizacjach.</div>"
      role.author_id = creator_id
      role.save!
    end
  end

  # proposals
  def proposal_j_admin(creator_id=nil)
    role = Role.find_or_create_by!(name: "Administrator Wniosków JST") do |role|
      role.activities += %w(proposal_j:index proposal_j:show proposal_j:create proposal_j:update proposal_j:delete proposal_j:work proposal_j:approve proposal_j:reject proposal_j:annul)
      role.note = "<div>Rola służy do zarządzania wszystkimi Wnioskami JST.<br>(Przypisz tylko zaawansowanym Administratorom systemu)</div>"
      role.author_id = creator_id
      role.save!
    end
  end 
  def proposal_j_observer(creator_id=nil)
    role = Role.find_or_create_by!(name: "Obserwator Wniosków JST") do |role|
      role.activities += %w(proposal_j:index proposal_j:show)
      role.note = "<div>Rola służy do wyświetlania informacji o Wnioskach JST.</div>"
      role.author_id = creator_id
      role.save!
    end
  end
  def proposal_j_referent(creator_id=nil)
    role = Role.find_or_create_by!(name: "Referent Wniosków JST") do |role|
      role.activities += %w(proposal_j:index proposal_j:show proposal_j:create proposal_j:work proposal_j:approve proposal_j:reject)
      role.note = "<div>Rola służy do rejestrowania i akceptowania Wniosków JST.</div>"
      role.author_id = creator_id
      role.save!
    end
  end 

  def proposal_p_admin(creator_id=nil)
    role = Role.find_or_create_by!(name: "Administrator Wniosków PP") do |role|
      role.activities += %w(proposal_p:index proposal_p:show proposal_p:create proposal_p:update proposal_p:delete proposal_p:work proposal_p:approve proposal_p:reject proposal_p:annul)
      role.note = "<div>Rola służy do zarządzania wszystkimi Wnioskami PP.<br>(Przypisz tylko zaawansowanym Administratorom systemu)</div>"
      role.author_id = creator_id
      role.save!
    end
  end 
  def proposal_p_observer(creator_id=nil)
    role = Role.find_or_create_by!(name: "Obserwator Wniosków PP") do |role|
      role.activities += %w(proposal_p:index proposal_p:show)
      role.note = "<div>Rola służy do wyświetlania informacji o Wnioskach PP.</div>"
      role.author_id = creator_id
      role.save!
    end
  end
  def proposal_p_referent(creator_id=nil)
    role = Role.find_or_create_by!(name: "Referent Wniosków PP") do |role|
      role.activities += %w(proposal_p:index proposal_p:show proposal_p:create proposal_p:work proposal_p:approve proposal_p:reject)
      role.note = "<div>Rola służy do rejestrowania i akceptowania Wniosków PP.</div>"
      role.author_id = creator_id
      role.save!
    end
  end 


  def proposal_t_admin(creator_id=nil)
    role = Role.find_or_create_by!(name: "Administrator Wniosków PT") do |role|
      role.activities += %w(proposal_t:index proposal_t:show proposal_t:create proposal_t:update proposal_t:delete proposal_t:work  proposal_t:approve proposal_t:reject proposal_t:annul)
      role.note = "<div>Rola służy do zarządzania wszystkimi Wnioskami PT.<br>(Przypisz tylko zaawansowanym Administratorom systemu)</div>"
      role.author_id = creator_id
      role.save!
    end
  end 
  def proposal_t_observer(creator_id=nil)
    role = Role.find_or_create_by!(name: "Obserwator Wniosków PT") do |role|
      role.activities += %w(proposal_t:index proposal_t:show)
      role.note = "<div>Rola służy do wyświetlania informacji o Wnioskach PT.</div>"
      role.author_id = creator_id
      role.save!
    end
  end
  def proposal_t_referent(creator_id=nil)
    role = Role.find_or_create_by!(name: "Referent Wniosków PT") do |role|
      role.activities += %w(proposal_t:index proposal_t:show proposal_t:create proposal_t:work  proposal_t:approve proposal_t:reject)
      role.note = "<div>Rola służy do rejestrowania i akceptowania Wniosków PT.</div>"
      role.author_id = creator_id
      role.save!
    end
  end 


  # registers
  def register_j_admin(creator_id=nil)
    role = Role.find_or_create_by!(name: "Administrator Rejestru JST") do |role|
      role.activities += %w(register_j:index register_j:show register_j:create register_j:update register_j:delete register_j:work)
      role.note = "<div>Rola służy do zarządzania wszystkimi Wnioskami JST.<br>(Przypisz tylko zaawansowanym Administratorom systemu)</div>"
      role.author_id = creator_id
      role.save!
    end
  end 
  def register_j_observer(creator_id=nil)
    role = Role.find_or_create_by!(name: "Obserwator Rejestru JST") do |role|
      role.activities += %w(register_j:index register_j:show)
      role.note = "<div>Rola służy do wyświetlania informacji o Wnioskach JST.</div>"
      role.author_id = creator_id
      role.save!
    end
  end

  def register_p_admin(creator_id=nil)
    role = Role.find_or_create_by!(name: "Administrator Rejestru PP") do |role|
      role.activities += %w(register_p:index register_p:show register_p:create register_p:update register_p:delete register_p:work)
      role.note = "<div>Rola służy do zarządzania wszystkimi Wnioskami PP.<br>(Przypisz tylko zaawansowanym Administratorom systemu)</div>"
      role.author_id = creator_id
      role.save!
    end
  end 
  def register_p_observer(creator_id=nil)
    role = Role.find_or_create_by!(name: "Obserwator Rejestru PP") do |role|
      role.activities += %w(register_p:index register_p:show)
      role.note = "<div>Rola służy do wyświetlania informacji o Wnioskach PP.</div>"
      role.author_id = creator_id
      role.save!
    end
  end

  def register_t_admin(creator_id=nil)
    role = Role.find_or_create_by!(name: "Administrator Rejestru PT") do |role|
      role.activities += %w(register_t:index register_t:show register_t:create register_t:update register_t:delete register_t:work)
      role.note = "<div>Rola służy do zarządzania wszystkimi Wnioskami PT.<br>(Przypisz tylko zaawansowanym Administratorom systemu)</div>"
      role.author_id = creator_id
      role.save!
    end
  end 
  def register_t_observer(creator_id=nil)
    role = Role.find_or_create_by!(name: "Obserwator Rejestru PT") do |role|
      role.activities += %w(register_t:index register_t:show)
      role.note = "<div>Rola służy do wyświetlania informacji o Wnioskach PT.</div>"
      role.author_id = creator_id
      role.save!
    end
  end

end
