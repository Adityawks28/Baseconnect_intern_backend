class Api::V1::JobsController < ApplicationController
  def index
    categories = params[:categories].present? ? params[:categories].split(",") : []
    min_salary = params[:minSalary].presence&.to_i
    page       = (params[:page].presence || 1).to_i
    per_page   = [(params[:pageSize].presence || 10).to_i, 50].min

    scope = Job.order(created_at: :desc)
    scope = scope.where(category: categories) if categories.any?
    scope = scope.where("salary_manyen >= ?", min_salary) if min_salary

    total = scope.count
    items = scope.limit(per_page).offset((page - 1) * per_page)

    render json: {
      total:, page:, pageSize: per_page,
      items: items.as_json(only: [:id, :title, :category], methods: [:salaryManYen, :createdAt])
    }
  end

  def show
    job = Job.find_by(id: params[:id])
    return render json: { error: "not_found" }, status: :not_found unless job
    render json: job.as_json(only: [:id, :title, :category], methods: [:salaryManYen, :createdAt])
  end

  def create
    job = Job.new(
      title: params[:title].to_s,
      category: params[:category].to_s,
      salary_manyen: params[:salaryManYen].to_i
    )
    return render json: { error: "validation_error" }, status: :bad_request unless job.valid?
    job.save!
    render json: job.as_json(only: [:id, :title, :category], methods: [:salaryManYen, :createdAt]), status: :created
  end
end
