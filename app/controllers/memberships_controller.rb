class MembershipsController < ApplicationController
  
  def plans
  end
  
  def bronze
    @user = User.find(params[:id])
    level = MembershipLevel.find_by(name: "Bronze")
    # TODO we need some sort of security token check here to make sure they've signed up properly
    @user.membership_level = level
    @user.save
    flash[:success] = "You are now a Bronze Membership level TechScreen member!"
    redirect_to root_url
  end 

  def gold
    @user = User.find(params[:id])
    level = MembershipLevel.find_by(name: "Gold")
    # TODO we need some sort of security token check here to make sure they've signed up properly
    @user.membership_level = level
    @user.save
    flash[:success] = "You are now a Gold Membership level TechScreen member!"
    redirect_to root_url
  end 

  def bronze
    @user = User.find(params[:id])
    level = MembershipLevel.find_by(name: "Platinum")
    # TODO we need some sort of security token check here to make sure they've signed up properly
    @user.membership_level = level
    @user.save
    flash[:success] = "You are now a Platinum Membership level TechScreen member!"
    redirect_to root_url
  end 
  
end