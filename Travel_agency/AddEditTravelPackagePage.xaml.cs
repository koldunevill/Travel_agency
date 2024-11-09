using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations.Model;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Imaging;
using System.Windows.Threading;

namespace Travel_agency
{
    public partial class AddEditTravelPackagePage : Page
    {
        private Путевки currentPackage;
        private Клиенты currentClients;
        private Пансионаты пансионаты;
        private bool isSettingIndex = false;


        public AddEditTravelPackagePage(Путевки package = null)
        {
            var clients = new List<string>
            {
                "-"
            };
            clients.AddRange(Travel_agencyEntities.GetContext().Клиенты.Select(f => f.Фамилия + " " + f.Имя + " " + f.Отчество).ToList());
            InitializeComponent();
            SelectCLient.ItemsSource = clients;
            currentPackage = package ?? new Путевки();
            ComboBoxPansionat.ItemsSource = Travel_agencyEntities.GetContext().Пансионаты.Select(f => f.Название).ToList();
            ComboBoxHousingType.ItemsSource = Travel_agencyEntities.GetContext().Виды_жилья.Select(f => f.Название).ToList();
            ComboBoxTour.ItemsSource = Travel_agencyEntities.GetContext().Туры.Select(f => f.ID_Тура + " " + f.Название + " " + f.Цена_тура_в_сутки).ToList();

            DispatcherTimer timer = new DispatcherTimer();
            timer.Interval = TimeSpan.FromMilliseconds(250);  
            timer.Tick += (s, e) =>
            {
                if (currentPackage.ID_Путевки == 0)
                {
                    SelectCLient.SelectedIndex = 0;
                }
                else
                {
                    if (currentPackage.ID_Пансионата != null)
                    {
                        ComboBoxPansionat.SelectedIndex = (int)currentPackage.ID_Пансионата - 1;
                        ComboBoxHousingType.SelectedIndex = (int)currentPackage.ID_Вид_жилья - 1;
                        ComboBoxTour.Visibility = Visibility.Collapsed;
                    }
                    else
                    {
                        ComboBoxTour.SelectedIndex = (int)currentPackage.ID_Тура - 1;
                        ComboBoxHousingType.Visibility = Visibility.Collapsed;
                        ComboBoxPansionat.Visibility = Visibility.Collapsed;
                    }
                    SelectCLient.SelectedIndex = currentPackage.ID_Клиента;


                    ArrivalDatePicker.SelectedDate = currentPackage.Дата_заезда;
                    DepartureDatePicker.SelectedDate = currentPackage.Дата_отъезда;
                    PeopleCountTextBox.Text = currentPackage.Количество_человек.ToString();
                    PriceTextBox.Text = currentPackage.Цена.ToString();
                    ChildrenCheckBox.IsChecked = currentPackage.Наличие_детей;
                    InsuranceCheckBox.IsChecked = currentPackage.Наличие_мед__страховки;


                }
                timer.Stop();  
            };
            timer.Start();  
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (SelectCLient.SelectedIndex == 0)
            {
                if (string.IsNullOrEmpty(Familia.Text) || string.IsNullOrEmpty(Name.Text) ||
                    !DateBird.SelectedDate.HasValue || string.IsNullOrEmpty(City.Text) ||
                    string.IsNullOrEmpty(Adres.Text) || string.IsNullOrEmpty(Phone.Text) ||
                    string.IsNullOrEmpty(Pasport.Text))
                {
                    MessageBox.Show("Пожалуйста, заполните все данные для клиента.");
                    return;
                }

                if (Pasport.Text.Length != 10)
                {
                    MessageBox.Show("Паспортные данные должны содержать ровно 10 символов.");
                    return;
                }
            }

            if (ComboBoxPansionat.SelectedIndex != -1)
            {
                currentPackage.ID_Пансионата = ComboBoxPansionat.SelectedIndex + 1;
                currentPackage.ID_Вид_жилья = ComboBoxHousingType.SelectedIndex + 1;
                currentPackage.ID_Тура = null; 
            }
            else if (ComboBoxTour.SelectedIndex != -1)
            {
                currentPackage.ID_Тура = ComboBoxTour.SelectedIndex + 1;
                currentPackage.ID_Пансионата = null; 
                currentPackage.ID_Вид_жилья = null;
            }
            else
            {
                MessageBox.Show("Пожалуйста, выберите пансионат или тур.");
                return;
            }
            if (!ArrivalDatePicker.SelectedDate.HasValue || !DepartureDatePicker.SelectedDate.HasValue)
            {
                MessageBox.Show("Пожалуйста, выберите даты заезда и отъезда.");
                return;
            }
            if (ArrivalDatePicker.SelectedDate.Value >= DepartureDatePicker.SelectedDate.Value)
            {
                MessageBox.Show("Дата заезда должна быть раньше даты отъезда.");
                return;
            }

            if (string.IsNullOrEmpty(PeopleCountTextBox.Text) || !int.TryParse(PeopleCountTextBox.Text, out int peopleCount) ||
                peopleCount < 1 || peopleCount > 4)
            {
                MessageBox.Show("Пожалуйста, укажите количество человек от 1 до 4.");
                return;
            }

            if (string.IsNullOrEmpty(PriceTextBox.Text) || !decimal.TryParse(PriceTextBox.Text, out decimal price))
            {
                MessageBox.Show("Пожалуйста, укажите корректную цену.");
                return;
            }

            if (ComboBoxPansionat.SelectedIndex != -1)
            {
                currentPackage.ID_Пансионата = ComboBoxPansionat.SelectedIndex + 1;
                currentPackage.ID_Вид_жилья = ComboBoxHousingType.SelectedIndex + 1;
                currentPackage.ID_Тура = null; 
            }
            else if (ComboBoxTour.SelectedIndex != -1)
            {
                currentPackage.ID_Тура = ComboBoxTour.SelectedIndex + 1;
                currentPackage.ID_Пансионата = null; 
                currentPackage.ID_Вид_жилья = null;
            }

            currentPackage.Дата_заезда = ArrivalDatePicker.SelectedDate.Value;
            currentPackage.Дата_отъезда = DepartureDatePicker.SelectedDate.Value;
            currentPackage.Количество_человек = int.Parse(PeopleCountTextBox.Text);
            currentPackage.Цена = decimal.Parse(PriceTextBox.Text);
            currentPackage.Наличие_детей = ChildrenCheckBox.IsChecked ?? false;
            currentPackage.Наличие_мед__страховки = InsuranceCheckBox.IsChecked ?? false;

            if (SelectCLient.SelectedIndex == 0)
            {
                Клиенты newClient = new Клиенты
                {
                    Паспортные_данные = Pasport.Text,
                    Фамилия = Familia.Text,
                    Имя = Name.Text,
                    Отчество = Patronomyc.Text,
                    Дата_рождения = DateBird.SelectedDate.Value,
                    Город = City.Text,
                    Адрес = Adres.Text,
                    Телефон = Phone.Text,
                    Фото = null 
                };

                
                Travel_agencyEntities.GetContext().Клиенты.Add(newClient);
                Travel_agencyEntities.GetContext().SaveChanges();

                currentPackage.ID_Клиента = newClient.ID_Клиента;
            }

            if (currentPackage.ID_Путевки == 0)
            {
                Travel_agencyEntities.GetContext().Путевки.Add(currentPackage);
            }

            Travel_agencyEntities.GetContext().SaveChanges();

            MessageBox.Show("Путевка успешно сохранена.");
            manager.MainFrame.GoBack();
        }


        private void SelectCLient_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (SelectCLient.SelectedIndex == 0)
            {
               
                Familia.Clear();
                Name.Clear();
                Patronomyc.Clear();
                DateBird.SelectedDate = null;
                City.Clear();
                Adres.Clear();
                Phone.Clear();
                Pasport.Clear();
            }
            else if (SelectCLient.SelectedIndex > 0) 
            {
               
                var selectedClientFullName = SelectCLient.SelectedItem.ToString();
                var selectedClient = Travel_agencyEntities.GetContext().Клиенты
                    .FirstOrDefault(c => c.Фамилия + " " + c.Имя + " " + c.Отчество == selectedClientFullName);

                if (selectedClient != null)
                {
                    
                    Familia.Text = selectedClient.Фамилия;
                    Name.Text = selectedClient.Имя;
                    Patronomyc.Text = selectedClient.Отчество;
                    DateBird.SelectedDate = selectedClient.Дата_рождения;
                    City.Text = selectedClient.Город;
                    Adres.Text = selectedClient.Адрес;
                    Phone.Text = selectedClient.Телефон;
                    Pasport.Text = selectedClient.Паспортные_данные;

                currentPackage.ID_Клиента = selectedClient.ID_Клиента;
                }
            }
        }

        private void GoBack_Click(object sender, RoutedEventArgs e)
        {
            manager.MainFrame.GoBack();
        }

        private void ComboBoxPansionat_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (ComboBoxPansionat.SelectedIndex != -1)
            {
                ComboBoxTour.Visibility = Visibility.Collapsed;
            }
        }

        private void ComboBoxHousingType_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (ComboBoxHousingType.SelectedIndex != -1)
            {
                ComboBoxTour.Visibility = Visibility.Collapsed;
            }
        }

        private void ComboBoxTour_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (ComboBoxTour.SelectedIndex != -1)
            {
                ComboBoxHousingType.Visibility = Visibility.Collapsed;
                ComboBoxPansionat.Visibility = Visibility.Collapsed;
            }
        }
    }
}

