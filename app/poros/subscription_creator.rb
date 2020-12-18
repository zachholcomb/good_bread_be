class SubscriptionCreator
  class << self
    def create_subscription(user, details)
      subscription = user.create_subscription(
        amount: details["amount"],
        flavors?: details["flavors?"]
      )
      if details["allergies"]
        allergies = find_or_create_allergies(details["allergies"])
        subscription_allergies(subscription, allergies)
      end
      subscription
    end

    def find_or_create_allergies(allergy_name_list)
      allergy_name_list.split(',').each do |name|
        if Allergy.where(name: name).blank?
          Allergy.create(name: name)
        end
      end
      Allergy.where(name: allergy_name_list.split(','))
    end

    def subscription_allergies(subscription, allergy_list)
      allergy_list.each do |allergy|
        SubscriptionAllergy.create(
          subscription: subscription,
          allergy: allergy
        )
      end
    end
  end
end