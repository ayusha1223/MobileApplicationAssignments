//---------------------- ABSTRACT CLASS ----------------------
abstract class BankAccount {
  //  Encapsulation with private fields
  int _accountNumber;
  String _holderName;
  double _balance;
  List<String> _transactions = [];

  // Constructor
  BankAccount(this._accountNumber, this._holderName, this._balance);

  // Getters and Setters
  int get accountNumber => _accountNumber;
  String get holderName => _holderName;
  double get balance => _balance;

  set balance(double newBalance) {
    if (newBalance >= 0) {
      _balance = newBalance;
    } else {
      print(" Invalid balance update!");
    }
  }

  // Abstract methods — Abstraction
  void deposit(double amount);
  void withdraw(double amount);

  // Display account info
  void displayInfo() {
    print("Account Number: $_accountNumber");
    print("Holder Name: $_holderName");
    print("Balance: \$${_balance.toStringAsFixed(2)}");
  }

  // ✅ Transaction tracking
  void addTransaction(String detail) {
    _transactions.add(detail);
  }

  void showTransactions() {
    print("\nTransaction History for $_holderName:");
    for (String t in _transactions) {
      print("- $t");
    }
  }
  
  void calculateInterest() {}
}

// ---------------------- INTERFACE ----------------------
abstract class InterestBearing {
  void calculateInterest();
}

// ---------------------- ACCOUNT TYPES ----------------------

class SavingsAccount extends BankAccount implements InterestBearing {
  int _withdrawCount = 0;
  static const int _withdrawLimit = 3;
  static const double _minBalance = 500.0;

  SavingsAccount(int number, String name, double balance)
      : super(number, name, balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print(" Deposit amount must be positive!");
      return;
    }
    balance += amount;
    addTransaction("Deposited \$${amount.toStringAsFixed(2)}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) {
      print("Withdrawal amount must be positive!");
      return;
    }
    if (_withdrawCount >= _withdrawLimit) {
      print(" Withdrawal limit reached!");
      return;
    }
    if (balance - amount < _minBalance) {
      print(" Minimum balance of \$$_minBalance required.");
      return;
    }
    balance -= amount;
    _withdrawCount++;
    addTransaction("Withdrew \$${amount.toStringAsFixed(2)}");
  }

  @override
  void calculateInterest() {
    double interest = balance * 0.02;
    balance += interest;
    addTransaction("Interest added: \$${interest.toStringAsFixed(2)}");
  }
}

class CheckingAccount extends BankAccount {
  static const double _overdraftFee = 35.0;

  CheckingAccount(int number, String name, double balance)
      : super(number, name, balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print(" Deposit amount must be positive!");
      return;
    }
    balance += amount;
    addTransaction("Deposited \$${amount.toStringAsFixed(2)}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) {
      print(" Withdrawal amount must be positive!");
      return;
    }
    balance -= amount;
    addTransaction("Withdrew \$${amount.toStringAsFixed(2)}");
    if (balance < 0) {
      balance -= _overdraftFee;
      addTransaction("Overdraft fee of \$$_overdraftFee applied");
    }
  }
}

class PremiumAccount extends BankAccount implements InterestBearing {
  static const double _minBalance = 10000.0;

  PremiumAccount(int number, String name, double balance)
      : super(number, name, balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print(" Deposit amount must be positive!");
      return;
    }
    balance += amount;
    addTransaction("Deposited \$${amount.toStringAsFixed(2)}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) {
      print(" Withdrawal amount must be positive!");
      return;
    }
    if (balance - amount < _minBalance) {
      print(" Minimum balance of \$$_minBalance required!");
      return;
    }
    balance -= amount;
    addTransaction("Withdrew \$${amount.toStringAsFixed(2)}");
  }

  @override
  void calculateInterest() {
    double interest = balance * 0.05;
    balance += interest;
    addTransaction("Interest added: \$${interest.toStringAsFixed(2)}");
  }
}

class StudentAccount extends BankAccount {
  static const double _maxBalance = 5000.0;

  StudentAccount(int number, String name, double balance)
      : super(number, name, balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print(" Deposit amount must be positive!");
      return;
    }
    if (balance + amount > _maxBalance) {
      print(" Cannot exceed maximum balance of \$$_maxBalance!");
      return;
    }
    balance += amount;
    addTransaction("Deposited \$${amount.toStringAsFixed(2)}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) {
      print("Withdrawal amount must be positive!");
      return;
    }
    if (balance - amount < 0) {
      print(" Insufficient funds!");
      return;
    }
    balance -= amount;
    addTransaction("Withdrew \$${amount.toStringAsFixed(2)}");
  }
}

// ---------------------- BANK CLASS ----------------------
class Bank {
  List<BankAccount> _accounts = [];

  void createAccount(BankAccount account) {
    _accounts.add(account);
    print(" Account for ${account.holderName} created successfully!");
  }

  BankAccount? findAccount(int accountNumber) {
    for (BankAccount acc in _accounts) {
      if (acc.accountNumber == accountNumber) {
        return acc;
      }
    }
    print("Account not found!");
    return null;
  }

  void transfer(int fromAccNum, int toAccNum, double amount) {
    BankAccount? from = findAccount(fromAccNum);
    BankAccount? to = findAccount(toAccNum);

    if (from == null || to == null) {
      print(" Transfer failed: Account not found!");
      return;
    }

    if (amount <= 0) {
      print(" Transfer amount must be positive!");
      return;
    }

    if (from.balance < amount) {
      print(" Transfer failed: Insufficient funds!");
      return;
    }

    from.withdraw(amount);
    to.deposit(amount);
    print(" Transferred \$${amount.toStringAsFixed(2)} from ${from.holderName} to ${to.holderName}");
  }

  void applyMonthlyInterest() {
    for (BankAccount acc in _accounts) {
      if (acc is InterestBearing) {
        acc.calculateInterest();
      }
    }
    print("\n Monthly interest applied to all interest-bearing accounts!");
  }

  void showAllAccounts() {
    print("\n Bank Accounts Summary:");
    for (BankAccount acc in _accounts) {
      acc.displayInfo();
      print("----------------------");
    }
  }
}

// ---------------------- MAIN FUNCTION ----------------------
void main() {
  Bank bank = Bank();

  SavingsAccount acc1 = SavingsAccount(101, "Ayusha", 2000.0);
  CheckingAccount acc2 = CheckingAccount(102, "Ansuya", 2000.0);
  PremiumAccount acc3 = PremiumAccount(103, "Sambridhi", 15000.0);
  StudentAccount acc4 = StudentAccount(104, "Resha", 20000.0);

  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);
  bank.createAccount(acc4);

  acc1.withdraw(200);
  acc1.withdraw(200);
  acc1.deposit(300);
  acc2.withdraw(500);
  bank.transfer(103, 104, 500);

  bank.applyMonthlyInterest();

  acc1.showTransactions();
  acc3.showTransactions();
  bank.showAllAccounts();
}
