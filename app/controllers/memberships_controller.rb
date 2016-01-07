class MembershipsController < ApplicationController
  
  def plans
  end
  
  def subscribe
    @user = User.find(params[:ref])
    product_id = params[:prod]
    subscription_id = params[:id] # unclear if this is useful
    
    level = MembershipLevel.find(product_id)
    # TODO we need some sort of security token check here to make sure they've signed up properly
    @user.membership_level = level
    @user.save
    flash[:success] = "You are now a " + level.name + " Membership level T3KSCR33N member!"
    redirect_to root_url
  end 
  
  def bronze
    full_key = params[:ref]
    if full_key.start_with?("4RKzhs3YJMNAAV2v7Zo")
      user_id = full_key["4RKzhs3YJMNAAV2v7Zo".length..full_key.length]
      @user = User.find(user_id)
      level = MembershipLevel.find_by(name: "Bronze")
      @user.membership_level = level
      @user.activate
      @user.save
      log_in @user
      flash[:success] = "You are now a Bronze Membership level T3KSCR33N member!"
      redirect_to root_url
    else
      flash[:error] = "Problem with sign up information..."
      redirect_to root_url
    end 
  end 

  def gold
    full_key = params[:ref]
    if full_key.start_with?("4RKzhs3YJMNAAV2v7Zo")
      user_id = full_key["4RKzhs3YJMNAAV2v7Zo".length..full_key.length]
      @user = User.find(user_id)
      level = MembershipLevel.find_by(name: "Gold")
      @user.membership_level = level
      @user.activate
      @user.save
      log_in @user
      flash[:success] = "You are now a Gold Membership level T3KSCR33N member!"
      redirect_to root_url
    else
      flash[:error] = "Problem with sign up information..."
      redirect_to root_url
    end 
  end 
  
  def platinum
    full_key = params[:ref]
    if full_key.start_with?("4RKzhs3YJMNAAV2v7Zo")
      user_id = full_key["4RKzhs3YJMNAAV2v7Zo".length..full_key.length]
      @user = User.find(user_id)
      level = MembershipLevel.find_by(name: "Platinum")
      @user.membership_level = level
      @user.activate
      @user.save
      log_in @user
      flash[:success] = "You are now a Platinum Membership level T3KSCR33N member!"
      redirect_to root_url
    else
      flash[:error] = "Problem with sign up information..."
      redirect_to root_url
    end 
  end 
  
end
