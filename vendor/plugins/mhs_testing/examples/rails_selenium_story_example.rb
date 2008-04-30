require File.expand_path(File.dirname(__FILE__) +  '/../helper')

Story "User creating misc. expense", %|
  As a user 
  I want be able to submit an expense reimbursement request for a misc. expense
  so that I can be reimbursed|,
  :steps_for => [:expense_reimbursements, :a_user_creating_a_misc_expense],
  :type => RailsSeleniumStory do
 
  Scenario "successfully creating a misc. expense" do
    Given "a user at a new expense reimbursement page" do
      open "/"
      click_link expense_reimbursements_path
    end  
    When "they click the add misc. expense link" do
      # clicking an link which doesn't submit, just does some javascript 
      click_link "Add Miscellaneous Expense", :makes_request => false
      wait_for_condition(
        "selenium.browserbot.getCurrentWindow().eval(\"$('new_expense_form').visible()\");",
        10000
      )
    end
    Then "they will see the new misc. expense form" do
      # select_form will ensure the form with the passed in id exists
      select_form id
    end
    
    When "they submit the misc. expense form with required information" do
      submit_form 'new_expense', options do |form|
        form.expense.date = "2007-01-01"
        form.expense.description = "Airport Internet Usage"
        form.expense.amount = "12.99"
        form.expense.category_id = ExpenseReimbursement.expense_categories.first.id
        form.expense.training_option_id = ExpenseReimbursement.training_options.first.id
      end
    end
    Then "they will see newly created misc. expense in the expense's list" do
      response.should have_tag("##{show_expense_dom_id(expense)}") do
        with_text(date_forma(expense.date))
        with_text(money_format(expense.amount))
        with_text(expense.description)
        with_text(expense.category.name)
      end
    end
  end
end

