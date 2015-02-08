class UsersController < ApplicationController
 def new
   @user = User.new
 end

 def create 
   @user = User.new(params[:user])
   if @user.save
     flash[:notice] = "You've signed up with Ankishare successfully"
     flash[:color] = "valid"
   else
     flash[:notice] = "Invalid email"
     flash[:color] = "invalid"
   end

   render "new"
 end
end
