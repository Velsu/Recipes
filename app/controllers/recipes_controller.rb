class RecipesController < ApplicationController
	before_action :find_recipe, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, except: [:show, :index]

	def index
		@recipe = Recipe.all.order(created_at: :desc)
	end

	def show
	end

	def new
		@recipe = current_user.recipes.build
	end

	def create
		@recipe = current_user.recipes.build(recipe_params)

		if @recipe.save
			redirect_to @recipe, notice: "Recipe successfully created"
		else
			render 'new'
		end
	end

	def destroy
		if correct_user
			@recipe.destroy
			redirect_to root_path, notice: "Recipe deleted successfully"
		else
			redirect_to root_url, notice: "Not authorized"
		end
	end

	def update
		if @recipe.update(recipe_params)
			redirect_to @recipe, notice: "Recipe successfully updated"
		else
			render 'edit'
		end
	end

	def edit
		unless correct_user
			redirect_to root_url, notice: "Not authorized to edit this recipe"
		end
	end









	private

	def recipe_params
		params.require(:recipe).permit(:title, :description, :image,
										ingredients_attributes: [:id, :name, :_destroy],
										directions_attributes: [:id, :step, :_destroy])
	end

	def find_recipe
		@recipe = Recipe.find(params[:id])
	end

	def correct_user
		@recipe = current_user.recipes.find_by(id: params[:id])
	end
end
