module Admin
  class SkillsController < BaseController
    def index
      @skills = Skill.order(:category, :name)
    end

    def new
      @skill = Skill.new
    end

    def create
      @skill = Skill.new(skill_params)
      if @skill.save
        flash[:notice] = "Compétence créée."
        redirect_to admin_skills_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @skill = Skill.find(params[:id])
    end

    def update
      @skill = Skill.find(params[:id])
      if @skill.update(skill_params)
        flash[:notice] = "Compétence mise à jour."
        redirect_to admin_skills_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @skill = Skill.find(params[:id])
      @skill.destroy
      flash[:notice] = "Compétence supprimée."
      redirect_to admin_skills_path
    end

    private

    def skill_params
      params.require(:skill).permit(:name, :category)
    end
  end
end
